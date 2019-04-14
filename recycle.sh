#!/bin/bash
dump=`dirname $0`/garbage

#Create the garbage folder if it does not exist
    #Should also touch the Tracker file
checkGarbage (){
if [ ! -d ./garbage ]
    then
        mkdir $dump
        touch $dump/tracker.info
        echo garbage created
    else
        echo garbage exists
fi
}

#Take in Arugments.
handleArgs(){
    while getopts 'ehxuz' OPTION; 
    do case $OPTION in
        e) echo option selected e;;
        h) echo option selected h;;
        x) echo option selected u;;
        u) echo option selected x;;
        z) echo option selected h ;;
        ?) echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" 
    esac
    done
    shift "$(($OPTIND -1))"
}

handleArgs $@


#Move the listed files to the dump
moveFile (){
    arg1=$1
    mv
}


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

# handle duplicate file names 
# handleArgs $@
echo $@
# checkGarbage