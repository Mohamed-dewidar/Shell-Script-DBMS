#!/bin/bash

printf "\n"
echo "#################"
echo "## LIST TABLES ##"
echo "#################"
printf "\n"

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))

if ((${#tablesList[@]}==0))
then
    echo "no tables, you will be redirected to manage home in 2 seconds"
    sleep 2
    source ./manageDatabase/manageHome.sh
else
 
    echo "List of all tables"
    printf "+----------------------+ \n"
    printf "%-1s %-20s %-1s \n" "|" "Name" "|"
    printf "+----------------------+ \n"

    for table in ${tablesList[@]}
    do  
        printf "| %-20s | \n" $table
    done

    printf "+----------------------+ \n"

    res=''
    until [[ $res =~ ^[Yy]$ ]]
    do
        read -p "back to manage home[y/n]: " res
    done

    source ./manageDatabase/manageHome.sh
fi