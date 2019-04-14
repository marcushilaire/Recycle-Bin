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



moveByArgs (){
    #not using this but do not delete
    #ask for a refresher on scope because i do not want to just run a for loop on moveFile
    for i in `seq $#`
        do 
            echo hello $i
        done
}

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

# checkGarbage