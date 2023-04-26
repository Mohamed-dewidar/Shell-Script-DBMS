#!/bin/bash

printf "\n"
echo "##################"
echo "## UPDATE TABLE ##"
echo "##################"

declare -A primSet
declare -A fieldSet
declare -A allFields
declare -A map
declare -A where
declare -A updateSet
primOrder=()
fieldOrder=()
db=$1
search=''
table=''
result=''



function selectMenu {
    printf "\n Choose Table \n"
    select choice in $@ "Back to Manage Home"
    do 

        if (($REPLY>$#+1)) || ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY==0))
        then
            echo "enter a valid number"
            continue
        fi

        if ((REPLY == $#+1))
        then
            source ./manageDatabase/manageHome.sh $db
        fi
        
        table=$choice
        break

    done
}


function getFields {
    count=0
    for rec in $(head -n1 ./DataBases/$db/$1 | awk  'BEGIN{RS=":"}{print $0}')
    do
        res=($(awk 'BEGIN{RS="&"}{print $0}' <<< $rec))
        if ((${#res[0]} > 1))
        then
            primSet[${res[1]}]=${res[0]:1}
            allFields[${res[1]}]=${res[0]:1}
            #primOrder+=(${res[1]})
        else
            fieldSet[${res[1]}]=${res[0]}
            allFields[${res[1]}]=${res[0]}
        fi
        ((count=$count+1))
        map[${res[1]}]=$count
        fieldOrder+=(${res[1]})
    done 
}

function whereCond {

    declare -A type
    type['i']='integer'
    type['s']='string'
    
    printf "\n where condition \n"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}+1))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]} "All"
    do 
        if ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY>limit))|| [[ $REPLY == 0 ]]
        then
            echo "Enter A valid number"
            continue
        fi
        echo $choice
        if [[ $choice =  'All' ]]
        then
            where[$choice]=1
            break
        fi

        ## Validate where values ##
        while [ true ]
        do
            value=${allFields[$choice]}

            read -p "Enter the $choice Value, and its type is ${type[$value]}  ==> " data 

            if [[ $data == "" ]]
            then 
                echo "no data were entered"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo "the $choice type is integer, enter valid data"
                continue
           
            fi
            

            where[$choice]=$data
            break
        done

        read -p "add or modifiy condition[y/n]: " res
        if [[ $res =~ [nN] ]]
        then
            break
        fi
    done
}



function setData {

    declare -A type
    type['i']='integer'
    type['s']='string'
    
    printf "\n choose fields to updates its value \n"
    limit=$((${#primOrder[@]}+${#fieldOrder[@]}))
    
    select choice in ${primOrder[@]} ${fieldOrder[@]}
    do 
        if ! [[ $REPLY =~ ^[0-9]+$ ]] || (($REPLY>limit))|| [[ $REPLY == 0 ]]
        then
            echo "Enter A valid number"
            continue
        fi
    
        

        ## Validate update values ##
        while [ true ]
        do
            value=${allFields[$choice]}

            read -p "Enter the $choice Value, and its type is ${type[$value]}  ==> " data 

            if [[ $data == "" ]]
            then 
                echo "no data were entered"
                continue
            fi

            if [[ $value = 'i' ]] && ! [[ $data =~ ^[0-9]+$ ]]
            then
                echo "the $choice type is integer, enter valid data"
                continue
            fi

            if [ ${primSet[$choice]} ]
            then
                 ## check unique if primary key ##
                if $(cut -d: -f"${map[$choice]}" ./DataBases/$db/$1 | grep -qx $data)
                then
                    echo "this primary key exists"
                    continue
                fi
            fi
            

            updateSet[$choice]=$data
            break
        done

        read -p "add or modifiy added fields to update[y/n]: " res
        if [[ $res =~ [nN] ]]
        then
            break
        fi
    done
}

function UpdateData {
    
    setPattern=''
    ## where condtion pattern ## 
    for key in ${primOrder[@]}
    do 
        if [ ${where[$key]} ]
        then
            search=$search${where[$key]}:
        else
            search=$search".*:"
        fi        
    done

    for key in ${fieldOrder[@]}
    do 
        if [ ${where[$key]} ]
        then
            search=$search${where[$key]}:
        else
            search=$search".*:"
        fi
    done
    
    ## values update pattern ##
    for key in ${primOrder[@]}
    do 
        if [ ${updateSet[$key]} ]
        then
            setPattern=$setPattern${updateSet[$key]}:
        else
            setPattern=$setPattern".*:"
        fi        
    done

    for key in ${fieldOrder[@]}
    do 
        if [ ${updateSet[$key]} ]
        then
            setPattern=$setPattern${updateSet[$key]}:
        else
            setPattern=$setPattern".*:"
        fi
    done

    if [ ${where['All']} ]
    then
        search=''
        for key in ${allFields[@]}
        do
            search+=".*:"
        done
    fi   
    search=${search:0:((${#search}-1))}  
    setPattern=${setPattern:0:((${#setPattern}-1))}


    gawk -i inplace -v pattern=$setPattern -v search=$search -F: 'BEGIN {split(pattern, patt, ":") split(search, sea, ":"); OFS=":"} 
    {   check=1
        if(NR==1){
            print $0;
            next;
        }
        for(i=1;i<=NF;i++){ 
          if(sea[i] != ".*" && sea[i] != $i){
            check=0;
            break;
          }     
        };
        if(check == 1){
        for(i=1;i<=NF;i++){
            if(patt[i] != ".*")
                $i = patt[i]
            }
        }
        ;
        print $0}' ./DataBases/$db/$1

}

## Main Script Statrs Here ##

tablesList=($(find ./DataBases/$1 -type f | cut -d/ -f4))


if ((${#tablesList[@]}==0))
then
    echo "no tables, you will be redirected to manage home in 2 seconds"
    sleep 2
    source ./manageDatabase/manageHome.sh
else
    PS3="Enter your selection Number ==> "
    
    selectMenu ${tablesList[@]}
    getFields $table
    whereCond
    setData $table
    UpdateData $table
    echo "table has been updated"
    source ./manageDatabase/update.sh $1
fi

