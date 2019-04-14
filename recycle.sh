#! /bin/bash

#Create the garbage folder if it does not exist
dump=`dirname $0`
checkGarbage (){
if [ ! -d ./garbage ]
then
    mkdir $dump/garbage
    echo garbage created
else
    echo garbage exists
fi
}
checkGarbage
echo $dump
