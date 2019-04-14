#! /bin/bash

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

checkArguments (){
echo $#
}
#Move the listed files to the dump
moveFile (){
    mv $1 $dump
}

#List all files in the recycle bin along with their size

#Create a file that records the original location of the file
    #Restore based on parsing throug that file
        #Cat through then pipe into a grep or awk
trackLocation(){
cat $dump/tracker.info |grep bye
}  
#


# handle duplicate file names 

checkGarbage