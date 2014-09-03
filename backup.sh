#!/bin/bash

#Command 
ECHO='/bin/echo'

#Variable
INPUT=
DIRECTORY=
FILESNAME=
DATE=
ARCMTD=


#Script


        $ECHO "1.   Specify directory to be backed up"
        $ECHO "2.   Specify files to be backed up (all files in directory [recursive] or files modified before a given date)"
        $ECHO "3.   Specify archive method (.zip or .tar or .tar.gz)"
        $ECHO "4.   Create Backup"
        $ECHO "5.   Restore from backup (warn if any files will be clobbered)"
        $ECHO "6.   Verify integrity of backup (compare it to an existing hash)"
        $ECHO "7.   Search backup for a string"
        $ECHO "8.   Encrypt backup archive"
        $ECHO "9.   Decrypt backup archive"
        $ECHO "10.  EXIT"
        #TODO limit number 1-10
        read -p "Enter Choice: " INPUT

if [ "$INPUT" == "1" ]; then
   #TODO: need validation here
    read -p "Please type the directory to be backed up: " $DIRECTORY
elif [ "$INPUT" == "2" ]; then
    $ECHO "Please select which files to backup"
    $ECHO "a. Backup All."
    $ECHO "b. Backup by selected Date"
    read -p "Enter Choice: " INPUT
    if [ "$INPUT" == "a" ];then
        $FILESNAME=*.*
    elif [ "$INPUT" == "b" ];then
        read -p "Please type a date, we will only backup files that were last modified before it." DATE
    fi
elif [ "$INPUT" == "3" ];then
    read -p "Please select your archive method" ARCMTD
fi


