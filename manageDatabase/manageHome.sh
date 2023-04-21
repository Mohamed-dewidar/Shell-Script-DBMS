#!/bin/bash

printf "\n"
echo "## MANAGE DATABASE"
echo "Connected to $1"

PS3="Enter your selection number ==> "
optionsList=("Create-Table" "List-Tables" "Drop-Table" "Insert-Into-Table" "Select-From-Table" "Update-Table" "Delete-Table")

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
        *) echo "Enter a valid Selection" ;;
    esac
done