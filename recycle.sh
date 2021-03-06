#!/bin/bash
dump=`dirname $0`/garbage
mode=recycle
currentDir=`pwd`



usage (){
    echo -e "Description: Recycle files then restore or permantently delete them \n"
    echo -e "$0 [OPTION]... [FILE]... \n"
    echo "Options"
    echo -e "Put mode and Delete mode are mutually exclusive\n"
    echo -e "-h Display this help page"
    echo -e "-L List all files and their sizes in the recycle bin"
    echo -e "-P Restore all files in the recycle bin"
    echo -e "-p [FILE]... PUT MODE. Restore one to many files"
    echo -e "-D Permanently delete all files in recycle bin"
    echo -e "-d [OPTION]... [FILE]... DELETE MODE. Delete one to many files. Allows for commands found in RM"
    echo -e "\t -- Proceed to delete without any rm options"
    echo -e "\t -r Recursive"
    echo -e "\t -i Interactive"
    echo -e "\t -f Force"
    echo -e "\t all sub options must be defined under the same flag [-]"
    echo -e "Example \t $0 -d -rfi fileOne directoryOne"
}

if [[ $1 =~ -[pd]{2} ]]
then
    usage
    exit 1
fi

while getopts ':hpLPDd:' OPTION; 
    do case $OPTION in
        d) mode=delete; input=$OPTARG;
            if [[ ! $input =~ -[-rfi]{0,3} ]]
            then 
            usage; exit 1
            fi
        ;;
        D) mode=Dall 
        ;;
        p) mode=put
        ;;
        P) mode=Pall
        ;;
        L) ls -sh $dump; exit 1
        ;;
        h) usage; exit 1
        ;;
        \?) usage; exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"

#Create the garbage folder if it does not exist
initiateGarbage (){
if [[ ! -d $dump || ! -f $dump/.tracker ]]
    then
        mkdir $dump 2> /dev/null
        touch $dump/.tracker
        echo garbage created
fi
}

#check to see if a file exists in garbage
checkGarbage (){
    if [[ -f $dump/$1 || -d $dump/$1 ]]
    then 
        return 1
    else
        return 0
    fi
}

findOrigin (){
    echo `cat $dump/.tracker | grep $1 |awk '{print $1}'`
}

recycleFile (){
        mv $1 $dump  
        if [[ $? -eq 0 ]]
        then
            echo -e `pwd` '\t' $1 >> $dump/.tracker
            echo recycling
            echo `ls -shc $dump/$1`
        fi
}

restoreFile (){
    local origin escaped
    origin=`echo $(findOrigin $1)`
    escaped=`echo $1| sed -e 's/\/$//'`
    mv $dump/$1 $origin
    if [[ $? -eq 0 ]]
    then
        sed -i "/$escaped/d" $dump/.tracker
    fi
}

deleteFlags (){
    local escaped
    escaped=`echo $2| sed -e 's/\/$//'`
    rm $dump/$2 $1
    if [[ $? -eq 0 ]]
    then
        sed -i "/$escaped/d" $dump/.tracker
    fi
}

main (){
initiateGarbage

#Delete All
if [[ $mode == 'Dall' ]]
then
    rm -rf $dump/*
    sed -i '1,$d' $dump/.tracker
    exit 0
fi

#Restore All
if [[ $mode == 'Pall' ]]
then 
    allFiles=`cat $dump/.tracker | awk '{print $2}'`
    for i in $allFiles
    do
        restoreFile $i
    done
    exit 0
fi

#Check for args
if [[ $# -eq 0 ]]
then
    usage; exit 1
fi

#Delete files
if [[ $mode == 'delete' ]]
then 
cd $dump
    for i in $@ 
    do
        deleteFlags $input $i
    done
cd $currentDir
fi

#Restore files
if [[ $mode == 'put' ]]
then 
cd $dump
    for i in $@
    do 
        restoreFile $i
    done
cd $currentDir
fi

#Recycle Files
if [[ $mode == 'recycle' ]]
then
    for i in $@ 
    do
        if checkGarbage $i
        then 
            recycleFile $i
        fi
    done
fi
}
main $@