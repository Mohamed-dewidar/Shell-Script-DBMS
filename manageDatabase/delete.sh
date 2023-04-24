#!/bin/bash

printf "\n"
echo "#######################"
echo "## DELETE FROM TABLE ##"
echo "#######################"
declare -A primSet
declare -A fieldSet
declare -A map
primOrder=()
fieldOrder=()
db=$1
record=''
table=''


function selectMenu {
        
    select choice in $@ "Back to Manage Home"
    do 

        if (($REPLY>$#+1)) || ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY==0))
        then
            echo "enter a valid number"
            continue
        fi

        if ((REPLY == $#+1))
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
            primOrder+=(${res[1]})
        else
            fieldSet[${res[1]}]=${res[0]}
            fieldOrder+=(${res[1]})
        fi
        ((count=$count+1))
        map[${res[1]}]=$count
    done 
}


function whereCond {
    printf "\n where condition \n"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}+1))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]} "All" 
    do 
        if (($REPLY>limit)) || ! [[ $REPLY =~ ^[0-9]+$ ]] || [[ $REPLY == 0 ]]
        then
            echo "Enter A valid number"
            continue
        fi

        echo $choice
    done
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

    fi
done