#!/bin/bash

printf "\n"
echo -e "${BBlue}#####################"
echo -e "${BBlue}## MANAGE DATABASE ##"
echo -e "${BBlue}#####################"
printf "\n"
echo -e "Connected to $1 ${Color_Off}"


optionsList=("Create-Table" "List-Tables" "Drop-Table" "Insert-Into-Table" "Select-From-Table" "Update-Table" "Delete-From-Table" "Main-menu")

select choice in ${optionsList[@]}
do 
    case $REPLY in
        1) source ./manageDatabase/createTable.sh $1;;
        2) source ./manageDatabase/listTables.sh $1;;
        3) source ./manageDatabase/dropTable.sh $1;;
        4) source ./manageDatabase/insert.sh $1;;
        5) source ./manageDatabase/select.sh $1;;
        6) source ./manageDatabase/update.sh $1;;
        7) source ./manageDatabase/delete.sh $1;;
        8) source ./mainMenu.sh;;
        *) echo -e "${Red}Enter a valid Selection${Color_Off}" ;;
    esac
done