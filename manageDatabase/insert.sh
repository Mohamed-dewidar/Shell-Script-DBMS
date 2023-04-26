#!/bin/bash

printf "\n"

echo -e "${BBlue}#######################"
echo -e "${BBlue}## INSERT INTO TABLE ##"
echo -e "${BBlue}#######################${Color_Off}"
printf "\n"

declare -A primSet
declare -A fieldSet
declare -A map
primSet=()
fieldSet=()
map=()
primOrder=()
fieldOrder=()
db=$1
record=''
table=''



function selectMenu {
        
    select choice in $@ "Back to Manage Home"
    do 

        if (($REPLY>$#+1)) || ! [[ $REPLY =~ ^[1-9]+0*$ ]]
        then
            echo -e "${Red}enter a valid number${Color_Off}"
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
    echo -e "${BBlue}Primary Keys add${Color_Off}"
    for key in ${primOrder[@]}
    do
        
        while [ true ]
        do
            value=${primSet[$key]}

            printf "${BCyan}Enter the $key Value, and its type is ${type[$value]}  ==> ${Color_Off}"
            read data

            if [[ $data == "" ]]
            then 
                echo -e "${Red}no data were entered${Color_Off}"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo -e "${Red}the $key type is integer, enter valid data${Color_Off}"
                continue
         
            fi
            
            ## check unique ##
            if $(cut -d: -f"${map[$key]}" ./DataBases/$db/$1 | grep -qx $data)
            then
                echo -e "${Red}this primary key exists${Color_Off}"
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
    echo -e "${BBlue}Fields add${Color_Off}"
    for key in ${fieldOrder[@]}
    do
        
        while [ true ]
        do
            value=${fieldSet[$key]}
            

            printf "${BCyan}Enter the $key Value, and its type is ${type[$value]}  ==> ${Color_Off}"
            read data 

            if [[ $data == "" ]]
            then 
                echo -e "${Red}no data were entered${Color_Off}"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo -e "${Red}the $key type is integer, enter valid data${Color_Off}"
                continue
            fi
            
            record=$record$data:
            break
        done
    done
    
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

    res='y'
    while [[ $res =~ ^[Yy]$ ]]
    do
        primaryKeyAdd $table
        fieldsAdd $table
        
        record=${record:0:((${#record}-1))}
        echo $record >> ./DataBases/$db/$table
        echo -e "${Green}The record was added successfully${Color_Off}"

        printf "${BCyan}Want to add more records[y/n]: ${Color_Off}"
        read res
    done
    source ./divide.sh
    source ./manageDatabase/manageHome.sh $db

fi



