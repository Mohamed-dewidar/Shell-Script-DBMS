#!/bin/bash

printf "\n"
echo "#######################"
echo "## SELECT FROM TABLE ##"
echo "#######################"
declare -A primSet
declare -A fieldSet
declare -A allFields
declare -A map
declare -A where
primOrder=()
fieldOrder=()
db=$1
search='^'
table=''
result=''


function selectMenu {
    printf "\n Choose Table \n"
    select choice in $@ "Back to Manage Home"
    do 

        if (($REPLY>$#+1)) || ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY==0))
        then
            echo "enter a valid number"
            continue
        fi

        if (($REPLY == $#+1))
        then
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
    
    printf "\n where condition \n"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}+1))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]} "All"
    do 
        if ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY>limit))|| [[ $REPLY == 0 ]]
        then
            echo "Enter A valid number"
            continue
        fi
        echo $choice
        if [[ $choice =  'All' ]]
        then
            where[$choice]=1
            break
        fi

        ## Validate where values ##
        while [ true ]
        do
            value=${allFields[$choice]}

            read -p "Enter the $choice Value, and its type is ${type[$value]}  ==> " data 

            if [[ $data == "" ]]
            then 
                echo "no data were entered"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo "the $choice type is integer, enter valid data"
                continue
            fi
            

            where[$choice]=$data
            break
        done

        read -p "add or modifiy condition[y/n]: " res
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
function printData {
    printf "\n"
    border=''
    for ((i=0 ; i < ${#allFields[@]} ; i++))
    do
        border=$border'+--------------------'  
    done
    border+='+'

    printf $border"\n"

    recPrint=''

    for ((i=0 ; i < ${#fieldOrder[@]} ; i++))
    do
        recPrint+="| %-18s "
    done
    recPrint+="| \n"
    printf "$recPrint" ${fieldOrder[@]}

    printf $border"\n"

    for row in ${result}
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
    
    printf $border"\n"

}




## Main Script Statrs Here ##

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))

while [ true ]
do
    if ((${#tablesList[@]}==0))
    then
        echo "no tables, you will be redirected to manage home in 2 seconds"
        sleep 2
        source ./manageDatabase/manageHome.sh
    else
        PS3="Enter your selection Number ==> "
        
        selectMenu ${tablesList[@]}
        getFields $table
        whereCond
        getData $table
        printData
        source ./manageDatabase/select.sh $1

    fi
    
done
