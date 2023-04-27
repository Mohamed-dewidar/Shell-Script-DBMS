#!/bin/bash

printf "\n"
echo -e "${BBlue}#######################"
echo -e "${BBlue}## SELECT FROM TABLE ##"
echo -e "${BBlue}#######################${Color_Off}"
declare -A primSet
declare -A fieldSet
declare -A allFields
declare -A map
declare -A where
declare -A selectCol
primSet=()
fieldSet=()
allFields=()
map=()
where=()
selectCol=()

primOrder=()
fieldOrder=()
db=$1
search='^'
table=''
result=''


function selectMenu {
    printf "${BBlue}\n Choose Table \n${Color_Off}"
    select choice in $@ "Back to Manage Home"
    do 

        if (($REPLY>$#+1)) || ! [[ $REPLY =~ ^[1-9]+0*$ ]]
        then
            echo -e "${Red}enter a valid number${Color_Off}"
            continue
        fi

        if (($REPLY == $#+1))
        then
            source ./divide.sh
            source ./manageDatabase/manageHome.sh $db
        fi
        
        table=$choice
        break

    done
}


function getFields {
    count=0
    for rec in $(head -n1 ./DataBases/$db/$1 | awk  'BEGIN{RS=":"}{print $0}')
    do
        res=($(awk 'BEGIN{RS="&"}{print $0}' <<< $rec))
        if ((${#res[0]} > 1))
        then
            primSet[${res[1]}]=${res[0]:1}
            allFields[${res[1]}]=${res[0]:1}
            #primOrder+=(${res[1]})
        else
            fieldSet[${res[1]}]=${res[0]}
            allFields[${res[1]}]=${res[0]}
        fi
        ((count=$count+1))
        map[${res[1]}]=$count
        fieldOrder+=(${res[1]})
    done 
}


function selectColumns {

    
    printf "${BBlue}\n columns to select \n${Color_Off}"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}+1))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]} "All"
    do 
        if ! [[ $REPLY =~ ^[1-9]+0*$ ]] || (($REPLY>limit))
        then
            echo -e "${Red}Enter A valid number${Color_Off}"
            continue
        fi
        
        if [[ $choice =  'All' ]]
        then
            selectCol[$choice]=1
            break
        fi

        selectCol[$choice]=1
        printf "${BCyan}add selection[y/n]: ${Color_Off}"
        read res
        if [[ $res =~ [nN] ]]
        then
            break
        fi
    done
}


function whereCond {

    declare -A type
    type['i']='integer'
    type['s']='string'
    
    printf "${BBlue}\n where condition \n${Color_Off}"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}+1))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]} "All"
    do 
        if ! [[ $REPLY =~ ^[1-9]+0*$ ]] || (($REPLY>limit))
        then
            echo -e "${Red}Enter A valid number${Color_Off}"
            continue
        fi
        
        if [[ $choice =  'All' ]]
        then
            where[$choice]=1
            break
        fi

        ## Validate where values ##
        while [ true ]
        do
            value=${allFields[$choice]}

            printf "${BCyan}Enter the $choice Value, and its type is ${type[$value]}  ==> ${Color_Off}"
            read data

            if [[ $data == "" ]]
            then 
                echo -e "${Red}no data were entered${Color_Off}"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo -e "${Red}the $choice type is integer, enter valid data${Color_Off}"
                continue
            fi
            

            where[$choice]=$data
            break
        done

        printf "${BCyan}add or modifiy condition[y/n]: ${Color_Off}"
        read res
        if [[ $res =~ [nN] ]]
        then
            break
        fi
    done
}


function getData {
    
    if [ ${where['All']} ]
    then
        result=$(sed -n '2,$p' ./DataBases/$db/$1)
        return
    fi

    for key in ${primOrder[@]}
    do 
        if [ ${where[$key]} ]
        then
            search=$search${where[$key]}:
        else
            search=$search".*:"
        fi        
    done

    for key in ${fieldOrder[@]}
    do 
        if [ ${where[$key]} ]
        then
            search=$search${where[$key]}:
        else
            search=$search".*:"
        fi
    done

    search=${search:0:((${#search}-1))}"$"
    result=$(sed -n '2,$p' ./DataBases/$db/$1 | sed -n "/$search/p")
}


function selectData {
    
    setPattern=''

    ## values update pattern ##
    for key in ${primOrder[@]}
    do 
        if [ ${selectCol[$key]} ]
        then
            setPattern=$setPattern"1:"
        else
            setPattern=$setPattern"0:"
        fi        
    done

    for key in ${fieldOrder[@]}
    do 
        if [ ${selectCol[$key]} ]
        then
            setPattern=$setPattern"1:"
        else
            setPattern=$setPattern"0:"
        fi
    done

    if [ ${selectCol['All']} ]
    then
        setPattern=''
        selectCol=()
        for key in ${!allFields[@]}
        do
            setPattern+="1:"
            selectCol[$key]=1
        done
    fi   
    setPattern=${setPattern:0:((${#setPattern}-1))}
   
    awkdata=""
    awkdata+=$(awk -v pattern=$setPattern -F: 'BEGIN {split(pattern, patt, ":"); OFS=":"; ORS="\n"} 
    {  
        str=""
        for(i=1;i<=NF;i++){ 
          if(patt[i] == "1"){
            str=str$i":"
          }     
        };
        print substr(str, 1, length(str)-1)
    }' <<< ${result})

}


function printData {

    printf "${Green}\n"
    border=''
    for ((i=0 ; i < ${#selectCol[@]} ; i++))
    do
        border=$border'+--------------------'  
    done
    border+='+'

    printf $border"\n"

    recPrint=''

    for ((i=0 ; i < ${#selectCol[@]} ; i++))
    do
        recPrint+="| %-18s "
    done
    recPrint+="| \n"

    selectOrder=()
    for key in ${fieldOrder[@]}
    do
        if [ ${selectCol[$key]} ]
        then
            selectOrder+=($key)
        fi
    done    
    printf "$recPrint" ${selectOrder[@]}

    printf $border"\n"

    for row in ${awkdata}
    do
        recPrint=''
        readarray -d: -t arr <<< $row
        for ((i=0 ; i < ${#arr[@]} ; i++))
        do
            recPrint+="| %-18s "
        done
        recPrint+="| \n"
        printf "$recPrint" ${arr[@]}

    done
    
    printf $border"\n${Color_Off} "

}



## Main Script Statrs Here ##

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))


if ((${#tablesList[@]}==0))
then
    echo -e "${Red}no tables, you will be redirected to manage home in 2 seconds${Color_Off}"
    sleep 2
    source  ./divide.sh
    source ./manageDatabase/manageHome.sh $db
else
    
    selectMenu ${tablesList[@]}
    getFields $table
    selectColumns
    whereCond
    getData $table
    selectData
    printData
 
    source ./divide.sh
    source ./manageDatabase/select.sh $db

fi
    
