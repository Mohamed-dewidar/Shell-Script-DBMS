#!/bin/bash

printf "\n"
echo "###############"
echo "## MAIN MENU ##"
echo "###############"
printf "\n"
PS3="Enter Your Selection Number ==> "
choiceList=("Create-Database" "List-Databases" "Connect-to-Database" "Drop-Database" "Exit")
select choice in ${choiceList[@]}
do
    
    case $REPLY in
    1) source ./createDatabase.sh;;
    2) source ./listDatabase.sh;;
    3) source ./connectToDatabase.sh;;
    4) source ./dropDatabase.sh;;
    5) exit;;
    *) echo "Enter a correct number";;
    esac
    
done