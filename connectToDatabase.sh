#!/bin/bash

printf "\n"
echo -e "${BBlue}###################"
echo -e "${BBlue}## Connect To DB ##"
echo -e "${BBlue}###################"
printf "\n"
echo -e "Choose DataBase to connect to${Color_Off}"


databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))

if ((${#databasesDir[@]}==0))
then
    echo -e "${Red}no Databases to drop, you will be redirected to main Menu in 2 seconds${Color_Off}"
    sleep 2
    source ./divide.sh
    source ./mainMenu.sh
else
    select choice in ${databasesDir[@]} "back to Main Menu"
    do

        if ! [[ $REPLY =~ ^[1-9]+0*$ ]]
        then
            echo -e "${Red}enter a valid Number${Color_Off}"
            continue
        fi
        
        if (($REPLY>${#databasesDir[@]}+1))
        then
            echo -e "${Red}enter a valid number${Color_Off}"
            continue
        fi

        if (($REPLY==${#databasesDir[@]}+1))
        then
            source ./divide.sh
            source ./mainMenu.sh
            break     
        fi

        source ./divide.sh
        source ./manageDatabase/manageHome.sh $choice
        break     
    done
fi

