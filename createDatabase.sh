#!/bin/bash


echo "##########################"
echo "## Create Your Database ##"
echo "##########################"

while [ true ]
do
    read -p "Enter Database Valid Name uppercase and lowercase letters only ==> " databaseName
    if [[ ${databaseName} =~ ^[a-z*A-Z*]+$  ]]
    then
        find ./DataBases -type d -name ${databaseName} | grep  ${databaseName} 2>&1 >/dev/null
        if (($?==0))
        then
            echo "database already Exists!!!"
        else
            mkdir ./DataBases/${databaseName}
            break
        fi 
    else
        echo "Enter a valid database Name"
    fi
done

echo "Successfully created new database with the name ${databaseName}"
source ./mainMenu.sh