#!/bin/bash
dump=`dirname $0`/garbage
#Parse through arguments and handle the option flags
while getopts ':ehxuz' OPTION; 
    do case $OPTION in
        e) e=true
        ;;
        h) h=true
        ;;
        \?) echo not a valid option
        ;;
    esac
done

shift "$(($OPTIND -1))"

main () {
    if [ $e ]
    then
        echo e set to true
    fi
    if [ $h ]
    then
        echo h is set to true
    fi
}
main


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

#Move the listed files to the dump and record their original location
moveFile (){
    for i in $@
    do
        if [ -f $i ]
        then
            echo `pwd`/$i >> $dump/tracker.info
            echo `ls -sh $i`
        else
            echo $i is not a valid file 
        fi
    done
}

moveFile $@
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

# handle duplicate file names 
# checkGarbage