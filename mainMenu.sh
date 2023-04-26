#!/bin/bash

printf "\n"
echo -e "${BBlue}###############"
echo -e "${BBlue}## MAIN MENU ##"
echo -e "${BBlue}###############${Color_Off}"
printf "\n"


choiceList=("Create-Database" "List-Databases" "Connect-to-Database" "Drop-Database" "Exit")
select choice in ${choiceList[@]}
do
    
    case $REPLY in
    1) source ./createDatabase.sh;;
    2) source ./listDatabase.sh;;
    3) source ./connectToDatabase.sh;;
    4) source ./dropDatabase.sh;;
    5) exit;;
    *) echo -e "${Red}Enter a correct number${Color_Off}";;
    esac
    
done