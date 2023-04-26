#!/bin/bash

printf "\n"
echo -e "${BBlue}################"
echo -e "${BBlue}## DROP TABLE ##"
echo -e "${BBlue}################"
printf "\n"
echo -e "Select a table to Drop${Color_Off}"

tableList=($(find ./DataBases/$1 -type f | cut -d/ -f4))

if ((${#tableList[@]}==0))
then
    echo -e "${Red}no tables, you will be redirected to manage home in 2 seconds${Color_Off}"
    sleep 2
    source ./divide.sh
    source ./manageDatabase/manageHome.sh $1
else
    select choice in ${tableList[@]} "back to manage home"
    do
        if ! [[ $REPLY =~ ^[1-9]+0*$ ]]
        then
            echo -e "${Red}enter a valid Number${Color_Off}"
            continue
        fi
        if (($REPLY>${#tableList[@]}+1))
        then
            echo -e "${Red}enter a valid number${Color_Off}"
            continue
        fi

        if (($REPLY==${#tableList[@]}+1))
        then
            source ./divide.sh
            source ./manageDatabase/manageHome.sh $1
            break     
        fi

        rm  DataBases/$1/$choice
        echo -e "${Green}The table with the name $choice was Dropped${Color_Off}"     
        source ./divide.sh
        source ./manageDatabase/manageHome.sh $1
    done
fi