#!/bin/bash

printf "\n"
echo "####################"
echo "## LIST DATABASES ##"
echo "####################"
printf "\n"

databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))

if ((${#databasesDir[@]}==0))
then
    echo "no Databases , you will be redirected to main menu in 2 seconds"
    sleep 2
    source ./mainMenu.sh
else
 
    echo "List of all Databases"
    printf "+----------------------+ \n"
    printf "%-1s %-20s %-1s \n" "|" "Name" "|"
    printf "+----------------------+ \n"

    for dir in ${databasesDir[@]}
    do  
        printf "| %-20s | \n" $dir
    done

    printf "+----------------------+ \n"

    res=''
    until [[ $res =~ ^[Yy]$ ]]
    do
        read -p "back to main menu[y/n]: " res
    done

    source ./mainMenu.sh
fi