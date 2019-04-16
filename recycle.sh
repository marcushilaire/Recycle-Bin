#!/bin/bash
dump=`dirname $0`/garbage
#Parse through arguments and handle the option flags
while getopts ':le' OPTION; 
    do case $OPTION in
        l) l=true #listing all files in the recycle bin
        ;;
        e) e=true #empty all files in recycle bin
        ;;
       # le) echo l and h are mutually exclusive, exiting.
       # ;; this does not seem to work here. handling later in the script
        \?) echo not a valid option
        ;;
    esac
done
shift "$(($OPTIND -1))"

#Create the garbage folder if it does not exist
initiateGarbage (){
if [ ! -d ./garbage ]
    then
        mkdir $dump
        touch $dump/tracker.info
        echo garbage created
fi
}

#check to see if a file exists in garbage
checkGarbage (){
    if [[ -f $dump/$1 || -d $dump/$1 ]]
    then 
        echo $i already exists in your Recycle Bin
        echo please rename the file you are attempting to recycle
        return 1
    else
        return 0
    fi
}

#Move the listed files to the dump and record their original location
recycleFile (){
    if [[ -f $1 || -d $1 ]]
    then
        echo `pwd`/$1 >> $dump/tracker.info
        echo `ls -shc $1`
        mv $1 $dump
    else
        echo $1 is not a valid file 
    fi
}

#List all files in the recycle bin along with their size
listFiles(){
    ls -sh $dump
}

findOrigin(){
    local origin
    origin=`cat $dump/tracker.info |grep $1`
    echo set from variable
    echo $origin
    #return origin does this work like it would in javascript
}  

main () {
    if [[ $l && $e ]]
    then echo l and e are mutually exclusive, exiting
    exit 1
    fi

    for i in $@
    do
        if checkGarbage $i
        then
            recycleFile $i
        fi
    done
}
main $@

# findOrigin $1

