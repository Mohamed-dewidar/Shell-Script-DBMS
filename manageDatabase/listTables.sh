#!/bin/bash

printf "\n"
echo -e "${BBlue}#################"
echo -e "${BBlue}## LIST TABLES ##"
echo -e "${BBlue}#################${Color_Off}"
printf "\n"

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))

if ((${#tablesList[@]}==0))
then
    echo -e "${Red}no tables, you will be redirected to manage home in 2 seconds${Color_Off}"
    sleep 2
    source ./divide.sh
    source ./manageDatabase/manageHome.sh $1
else
 
    echo -e "${Green}List of all tables"
    printf "+----------------------+ \n"
    printf "%-1s %-20s %-1s \n" "|" "Name" "|"
    printf "+----------------------+ \n"

    for table in ${tablesList[@]}
    do  
        printf "| %-20s | \n" $table
    done

    printf "+----------------------+ ${Color_Off}\n"

    res=''
    until [[ $res =~ ^[Yy]$ ]]
    do
        printf "${BCyan}back to manage home[y/n]: ${Color_Off}"
        read res
    done
    
    source ./divide.sh
    source ./manageDatabase/manageHome.sh $1
fi