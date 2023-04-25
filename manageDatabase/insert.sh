#!/bin/bash

printf "\n"

echo "#######################"
echo "## INSERT INTO TABLE ##"
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



function primaryKeyAdd {
    
    declare -A type
    type['i']='integer'
    type['s']='string'
    printf "\n"
    echo "Primary Keys add"
    for key in ${primOrder[@]}
    do
        
        while [ true ]
        do
            value=${primSet[$key]}

            read -p "Enter the $key Value, and its type is ${type[$value]}  ==> " data 

            if [[ $data == "" ]]
            then 
                echo "no data were entered"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo "the $key type is integer, enter valid data"
                continue
         
            fi
            
            ## check unique ##
            if $(cut -d: -f"${map[$key]}" ./DataBases/$db/$1 | grep -qx $data)
            then
                echo "this primary key exists"
                continue
            fi

            record=$record$data:
            break
        done
    done
    
}

function fieldsAdd {
    
    declare -A type
    type['i']='integer'
    type['s']='string'
    printf "\n"
    echo "Fields add"
    for key in ${fieldOrder[@]}
    do
        
        while [ true ]
        do
            value=${fieldSet[$key]}
            

            read -p "Enter the $key Value, and its type is ${type[$value]}  ==> " data 

            if [[ $data == "" ]]
            then 
                echo "no data were entered"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo "the $key type is integer, enter valid data"
                continue
            # elif ! [[ $value =~ ^[\w]$ ]]
            # then
            #     echo "primary key is String, enter a valid one"
            #     continue
            fi
            
            record=$record$data:
            break
        done
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
        primaryKeyAdd $table
        fieldsAdd $table
        
        record=${record:0:((${#record}-1))}
        echo $record >> ./DataBases/$db/$table
        echo "The record was added successfully"
        

        read -p "Want to add more records[y/n]: " res

        if [[ $res =~ ^[nN]$ ]]
        then
            source ./manageDatabase/manageHome.sh
        fi

    fi
done


