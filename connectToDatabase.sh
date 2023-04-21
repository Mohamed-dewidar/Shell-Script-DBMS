#!/bin/bash

printf "\n"
echo "Choose DataBase to connect to"
PS3="Select a Number ==> "

databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))

if ((${#databasesDir[@]}==0))
then
    echo "no Databases to drop, you will be redirected to main Menu in 2 seconds"
    sleep 2
    source ./mainMenu.sh
else
    select choice in ${databasesDir[@]} "back to Main Menu"
    do

        if ! [[ $REPLY =~ ^[0-9]+$ ]]
        then
            echo "enter a valid Number"
            continue
        fi
        
        if (($REPLY>${#databasesDir[@]}+1))
        then
            echo "enter a valid number"
            continue
        fi

        if (($REPLY==${#databasesDir[@]}+1))
        then
            source ./mainMenu.sh
            break     
        fi

        source ./manageDatabase/manageHome.sh $choice
        break     
    done
fi

