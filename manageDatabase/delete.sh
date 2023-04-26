#!/bin/bash

printf "\n"
echo -e "${BBlue}#######################"
echo -e "${BBlue}## DELETE FROM TABLE ##"
echo -e "${BBlue}#######################${Color_Off}"
printf "\n"

declare -A primSet
declare -A fieldSet
declare -A allFields
declare -A map
declare -A where
primSet=()
fieldSet=()
allFields=()
map=()
where=()

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
            echo -e"${Red}Enter A valid number${Color_Off}"
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


function deleteData {
    
    if [ ${where['All']} ]
    then
        numOfRec=$(sed -n '2,${p}' ./DataBases/$db/$1 | wc -l)
        result=$(sed -i '2,${d}' ./DataBases/$db/$1)
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
    numOfRec=$(sed -n "2,$ {/$search/p}" ./DataBases/$db/$1 | wc -l)
    result=$(sed -i "2,$ {/$search/d}" ./DataBases/$db/$1)
}

## Main Script Statrs Here ##

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))

if ((${#tablesList[@]}==0))
then
    echo -e "${Red}no tables, you will be redirected to manage home in 2 seconds${Color_Off}"
    sleep 2
    source ./divide.sh
    source ./manageDatabase/manageHome.sh $db
else
    
    selectMenu ${tablesList[@]}
    getFields $table
    whereCond
    deleteData $table
    echo  -e "${Green}${numOfRec} Record has been deleted${Color_Off}"
    source ./divide.sh
    source ./manageDatabase/delete.sh $1
  

fi
