#!/bin/bash

printf "\n"
echo -e "${BBlue}##################"
echo -e "${BBlue}## CREATE TABLE ##"
echo -e "${BBlue}##################${Color_Off}"
printf "\n"

declare -A fieldSet
fieldSet=()
db=$1
echo ${!fieldSet[@]}
## Table name
while [ true ]
do
    printf "${BCyan}Enter a valid table name uppercase and lowercase letters only ==> ${Color_Off}"
    read tableName
    if [[ ${tableName} =~ ^[a-z*A-Z*]+$  ]]
    then
        find ./DataBases/$db -type f -name ${tableName} | grep  ${tableName} 2>&1 >/dev/null
        if (($?==0))
        then
            echo -e "${Red}table already Exists!!!${Color_Off}"
        else
            touch ./DataBases/${db}/${tableName}
            break
        fi 
    else
        echo -e "${Red}Enter a valid table Name${Color_Off}"
    fi
done

printf "\n"
fields=""

# Primary Keys
while [ true ]
do 
    printf "${BCyan}Enter the primary key Column Name ==> ${Color_Off}"
    read colName
    if [[ ${colName} =~ ^[a-z*A-Z*]+$  ]]
    then
     
        if [[ ${fieldSet[$colName]}  ]]
        then
            echo -e "${Red}Column Name Exists!!!${Color_Off}"
        else
            fieldSet["$colName"]=1

            while [ true ]
            do
                printf "${BCyan}Select Datatype String or int [s/i]: ${Color_Off}"
                read type
                if [[ $type =~ ^[Ss]$ ]]
                then 
                    colName="#s&"$colName
                    break
                fi

                if [[ $type =~ ^[Ii]$ ]]
                then 
                    colName="#i&"$colName
                    break
                fi
                echo -e "${Red}enter a valid type${Color_Off}"
            done

            fields=$fields$colName
            break   
        fi 
    else
        echo -e "${Red}Enter a valid column name${Color_Off}"
    fi

done

# Fields
while [ true ]
do 

    printf "\n"
    printf "${BCyan}Enter Column Name ==> ${Color_Off}" 
    read colName
    if [[ ${colName} =~ ^[a-z*A-Z*]+$  ]]
    then
        if [[ ${fieldSet["$colName"]} ]]
        then
            echo -e "${Red}Column Name Exists!!!${Color_Off}"
        else
            fieldSet[$colName]=1

            while [ true ]
            do
                printf "${BCyan}Select Datatype String or int [s/i]: ${Color_Off}"
                read type
                if [[ $type =~ ^[Ss]$ ]]
                then 
                    colName="s&"$colName
                    break
                fi

                if [[ $type =~ ^[Ii]$ ]]
                then 
                    colName="i&"$colName
                    break
                fi
                echo -e "${Red}enter a valid type${Color_Off}"
            done

            fields=$fields":"$colName
            printf "${BCyan}Want to enter more fields[y/n]: ${Color_Off}"
            read res
            if [[ $res =~ [Nn] ]]
            then    
                break
            fi
        fi 
    else
        echo -e "${Red}Enter a valid column name${Color_Off}"
    fi

done


# Creation complete
printf "\n"
echo -e "${Green}table ${tableName} was created Successfully${Color_Off}"

echo $fields >> ./DataBases/${db}/${tableName}

source ./divide.sh
source ./manageDatabase/manageHome.sh $1