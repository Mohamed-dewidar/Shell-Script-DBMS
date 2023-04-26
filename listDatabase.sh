#!/bin/bash

printf "\n"
echo -e "${BBlue}####################"
echo -e "${BBlue}## LIST DATABASES ##"
echo -e "${BBlue}####################${Color_Off}"
printf "\n"

databasesDir=($(find ./DataBases -mindepth 1 -type d | cut -d/ -f3))

if ((${#databasesDir[@]}==0))
then
    echo -e "${Red}no Databases , you will be redirected to main menu in 2 seconds${Color_Off}"
    sleep 2
    source ./divide.sh
    source ./mainMenu.sh
else
 
    echo -e "${BGreen}List of all Databases"
    printf "+----------------------+ \n"
    printf "%-1s %-20s %-1s \n" "|" "Name" "|"
    printf "+----------------------+ \n"

    for dir in ${databasesDir[@]}
    do  
        printf "| %-20s | \n" $dir
    done

    printf "+----------------------+ ${Color_Off}\n"

    res=''
    until [[ $res =~ ^[Yy]$ ]]
    do
        printf "${BCyan}back to main menu[y/n]: ${Color_Off}"
        read res
    done
    source ./divide.sh
    source ./mainMenu.sh
fi