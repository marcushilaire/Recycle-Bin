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
    #Should also touch the Tracker file
initiateGarbage (){
if [ ! -d ./garbage ]
    then
        mkdir $dump
        touch $dump/tracker.info
        echo garbage created
    else
        echo garbage exists
fi
}

#check to see if a file exists in garbage
checkGarbage (){
    echo checking garbage to see if a file exists
    if [[ -f $dump/$1 || -d $dump/$1 ]]
    then 
    echo $i already exists in your Recycle Bin
    echo please rename the file you are attempting to recycle
    return 1
    else
    echo proceeding
    return 0
    fi
}

#Move the listed files to the dump and record their original location
recycleFile (){
    # for i in $@
    # do
        if [[ -f $1 || -d $1 ]]
        then
            mv $1 $dump
            echo `pwd`/$1 >> $dump/tracker.info
            echo `ls -shc $1`
        else
            echo $1 is not a valid file 
        fi
    # done
}

# recycleFile $@
# echo
#List all files in the recycle bin along with their size
listFiles(){
    ls -sh $dump
}

#Create a file that records the original location of the file
    #Restore based on parsing throug that file
        #Cat through then pipe into a grep or awk
trackLocation(){
cat $dump/tracker.info |grep bye
}  
#
main () {
    if [[ $l && $e ]]
    then echo l and e are mutually exclusive, exiting
    exit 1
    fi
    
    if [ $l ]
    then
        echo l set to true
    fi

    if [ $e ]
    then
        echo e is set to true
    fi

    for i in $@
    do
        checkGarbage $i
            # if [ checkGarbage $i ]
            # then
            #     echo check passed
            # else
            #     echo check failed
            # fi
    done
}
main $@

