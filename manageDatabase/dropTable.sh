#!/bin/bash

printf "\n"
echo "################"
echo "## DROP TABLE ##"
echo "################"
printf "\n"
echo "Select a table to Drop"

tableList=($(find ./DataBases/$1 -type f | cut -d/ -f4))
echo ${tableList[@]}
if ((${#tableList[@]}==0))
then
    echo "no tables, you will be redirected to manage home in 2 seconds"
    sleep 2
    source ./manageDatabase/manageHome.sh
else
    select choice in ${tableList[@]} "back to manage home"
    do
        if ! [[ $REPLY =~ ^[0-9]+$ ]]
        then
            echo "enter a valid Number"
            continue
        fi
        if (($REPLY>${#tableList[@]}+1))
        then
            echo "enter a valid number"
            continue
        fi

        if (($REPLY==${#tableList[@]}+1))
        then
            source ./manageDatabase/manageHome.sh
            break     
        fi

        rm  DataBases/$1/$choice
        echo "The table with the name $choice was Dropped"     
        source ./manageDatabase/dropTable.sh
    done
fi