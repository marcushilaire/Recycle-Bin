#!/bin/bash
dump=`dirname $0`/garbage

while getopts ':lem:i' OPTION; 
    do case $OPTION in
        l) l=true #listing all files in the recycle bin
        ;;
        e) e=true echo e is selected
        #empty all files in recycle bin
        ;;
        m) echo m is selected; input=$OPTARG
        echo $input
        ;;
        \?) echo not a valid option
        ;;
    esac
done
shift "$(($OPTIND -1))"
echo $@

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
        return 1
    else
        return 0
    fi
}

#Move the listed files to the dump and record their original location


#List all files in the recycle bin along with their size
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
            echo `ls -shc $dump/$1`
        fi
}

restoreFile (){
    local origin
    origin=`echo $(findOrigin $1)`
    mv $dump/$1 $origin
    if [[ $? -eq 0 ]]
    then
        sed -i "/$1/d" $dump/tracker.info
    fi
}

deleteFile (){
    local origin
    origin=`echo $(findOrigin $1)`
    rm $dump/$1
    if [[ $? -eq 0 ]]
    then
        sed -i "/$1/d" $dump/tracker.info
    fi
}


main (){
    initiateGarbage

    for i in $@
    do
        if checkGarbage $i
        then
            recycleFile $i
        else
            echo this file alreaedy exists in your recycle bin.
            echo please rename in order to avoid overwriting.
        fi
        
    done
}
# main $@

# restoreFile $1
