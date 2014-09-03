#!/bin/bash

#Command 
ECHO='/bin/echo'

#Variable
INPUT=
DIRECTORY=
FILESNAME=
DATE=

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

        read -p "Enter Choice: " INPUT

        echo $INPUT
if [ "$INPUT" == "1" ]; then
    echo "hello"
    read -p "Please type the directory to be backed up: " $DIRECTORY
fi
