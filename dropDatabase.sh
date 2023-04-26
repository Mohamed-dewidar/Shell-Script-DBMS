#!/bin/bash


printf "\n"
echo -e "${BBlue}###################"
echo -e "## DROP DATABASE ##"
echo -e "###################"
printf "\n"
echo -e " Choose DataBase to Drop${Color_Off}"

databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))

if ((${#databasesDir[@]}==0))
then
    echo "no Databases, you will be redirected to main menu in 2 seconds"
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
            source ./mainMenu.sh
            break     
        fi

        rm -r DataBases/$choice
        echo -e "${Green}The database with the name $choice was Dropped${Color_Off}"     
        source ./divide.sh
        source ./mainMenu.sh
    done
fi
