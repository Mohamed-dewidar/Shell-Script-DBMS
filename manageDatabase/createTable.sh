#!/bin/bash

printf "\n"
echo "## CREATE TABLE ##"

declare -A fieldSet
db=$1
## Table name
while [ true ]
do
    read -p "Enter a valid table name uppercase and lowercase letters only ==> " tableName
    if [[ ${tableName} =~ ^[a-z*A-Z*]+$  ]]
    then
        find ./DataBases/$db -type f -name ${tableName} | grep  ${tableName} 2>&1 >/dev/null
        if (($?==0))
        then
            echo "table already Exists!!!"
        else
            touch ./DataBases/${db}/${tableName}
            break
        fi 
    else
        echo "Enter a valid table Name"
    fi
done

printf "\n"
fields=""

# Primary Keys
while [ true ]
do 
    read -p "Enter the primary key Column Name ==> " colName
    if [[ ${colName} =~ ^[a-z*A-Z*]+$  ]]
    then
     
        if [[ ${fieldSet[$colName]}  ]]
        then
            echo "Column Name Exists!!!"
        else
            fieldSet["$colName"]=1

            while [ true ]
            do
                read -p "Select Datatype String or int [s/i]: " type
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
                echo "enter a valid type"
            done

            fields=$fields$colName
            break   
        fi 
    else
        echo "Enter a valid column name"
    fi

done

# Fields
while [ true ]
do 

    printf "\n"
    read -p "Enter Column Name ==> " colName
    if [[ ${colName} =~ ^[a-z*A-Z*]+$  ]]
    then
        if [[ ${fieldSet["$colName"]} ]]
        then
            echo "Column Name Exists!!!"
        else
            fieldSet[$colName]=1

            while [ true ]
            do
                read -p "Select Datatype String or int [s/i]: " type
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
                echo "enter a valid type"
            done

            fields=$fields":"$colName
            read -p "Want to enter more fields[y/n]: " res
            if [[ $res =~ [Nn] ]]
            then    
                break
            fi
        fi 
    else
        echo "Enter a valid column name"
    fi

done


# Creation complete
printf "\n"
echo "table ${tableName} was created Successfully"

echo $fields >> ./DataBases/${db}/${tableName}
cat ./DataBases/${db}/${tableName}
source ./manageDatabase/manageHome.sh