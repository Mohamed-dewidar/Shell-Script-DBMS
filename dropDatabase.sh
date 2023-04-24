#!/bin/bash


printf "\n"
echo "#######################"
echo "## DROP DATABASE ##"
echo "#######################"
printf "\n"
echo "Choose DataBase to Drop"
PS3="Select A number ==> "

databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))
echo ${databasesDir[@]}
if ((${#databasesDir[@]}==0))
then
    echo "no Databases, you will be redirected to main menu in 2 seconds"
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

        rm -r DataBases/$choice
        echo "The database with the name $choice was Dropped"     
        source ./dropDatabase.sh
    done
fi
