#!/bin/bash

printf "\n"
echo -e "${BBlue}#####################"
echo "## Create Database ##"
echo -e "#####################${Color_Off}"
printf "\n"
while [ true ]
do
    printf "${BCyan}Enter Database Valid Name uppercase and lowercase letters only ==> ${Color_Off}"
    read databaseName
    if [[ ${databaseName} =~ ^[a-z*A-Z*]+$  ]]
    then
        find ./DataBases -type d -name ${databaseName} | grep  ${databaseName} 2>&1 >/dev/null
        if (($?==0))
        then
            echo -e "${Red}database already Exists!!!${Color_Off}"
        else
            mkdir ./DataBases/${databaseName}
            break
        fi 
    else
        echo -e "${Red}Enter a valid database Name${Color_Off}"
    fi
done

echo -e "${Green}Successfully created new database with the name ${databaseName}${Color_Off}"
printf "\n"
source ./divide.sh
source ./mainMenu.sh