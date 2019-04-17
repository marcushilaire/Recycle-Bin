#!/bin/bash
dump=`dirname $0`/garbage
mode=recycle
currentDir=`pwd`


usage (){
    echo Descritption
    echo -e $0 [OPTION]... [FILE]"\t" Recycle files then restore or permantently delete them
    echo Usage
    
    echo Options
    echo -p
}


while getopts ':hpd:' OPTION; 
    do case $OPTION in
        d) mode=delete; input=$OPTARG;
            if [[ ! $input =~ -[-rfi]{0,3} ]]
            then 
            usage; exit 1
            fi
        ;; 
        p) mode=put
        ;;
        h) usage; exit 1
        ;;
        \?) echo not a valid option; exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"

#Create the garbage folder if it does not exist
initiateGarbage (){
if [[ ! -d $dump || ! -f $dump/tracker.info ]]
    then
        mkdir $dump 2> /dev/null
        touch $dump/tracker.info
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

listFiles (){
    ls -sh $dump
}

findOrigin (){
    echo `cat $dump/tracker.info | grep $1 |awk '{print $1}'`
}

recycleFile (){
        mv $1 $dump  
        if [[ $? -eq 0 ]]
        then
            echo -e `pwd` '\t' $1 >> $dump/tracker.info
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
        sed -i "/$escaped/d" $dump/tracker.info
    fi
}


deleteFlags (){
    local escaped
    escaped=`echo $2| sed -e 's/\/$//'`
    rm $dump/$2 $1
    if [[ $? -eq 0 ]]
    then
        sed -i "/$escaped/d" $dump/tracker.info
    fi
}


main (){
initiateGarbage

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