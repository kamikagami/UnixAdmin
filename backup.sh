#!/bin/bash

#Command 
ECHO='/bin/echo'
ZIP='/usr/bin/zip'
TAR='/usr/bin/tar'
UNZIP='/usr/bin/unzip'

#Variable
INPUT=
INPUT2=
DIRECTORY=
FILESNAME=
DATE=
ARCMTD=
BKNAME=
DST=

MD5_LEN=32
SHA1_LEN=40

#Script
while true; do
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

        case $INPUT in
            1)
            read -p "Please type the directory to be backed up: " DIRECTORY
            ;;
            2)
            $ECHO "Please select which files to backup"
            $ECHO "a. Backup All."
            $ECHO "b. Backup by selected Date"
            read -p "Enter Choice: " INPUT2
            case $INPUT2 in
                a)
                 FILENAME=*
                ;;
                b)
                read -p "Please type a date, we will only backup files that were last modified before it." DATE
                ;;
            esac
            ;;
            3)
            read -p "Please select your archive method(zip,tar or tgz)" ARCMTD
            ;;
            4)
            if [ ! -z $DATE ];then
                FILENAME=$(find $DIRECTORY ! -newermt $DATE)
            fi
            
            if [ $ARCMTD = "zip" ] && [ $INPUT2 = "a" ];then
                $ZIP -j "$USER-backup" $DIRECTORY/$FILENAME;
            elif [ "$ARCMTD" = "zip" ] && [ "$INPUT2" = "b" ];then
                $ZIP -j "$USER-backup" $FILENAME; #TODO complete MODIFIED DATE
            fi

            if [ "$ARCMTD" = "tar" ] && [ "$INPUT2" = "a" ];then
                $TAR -cvzf "$USER-backup.tar" $DIRECTORY/$FILENAME;
            elif [ "$ARCMTD" = "tar" ] && [ "$INPUT2" = "b" ];then
                #TODO complete modified date
                echo ""
            fi

            if [ "$ARCMTD" = "tgz" ] && [ "$INPUT2" = "a" ];then
                $TAR -cvzf "$USER-backup.tar.gz" $DIRECTORY/$FILENAME;
            elif [ "$ARCMTD" = "tgz" ] && [ "$INPUT2" = "b" ];then
               echo something here; 
               #TODO complete modified date
            fi 
            ;;
            5)
            read -p "Please input a backup file" BKNAME
            read -p "Please input a destination directory" DST
            
            if [ $BKNAME = *.zip ];then 
                $UNZIP $BKNAME -d $DST;
            elif [ $BKNAME = *.tar ] || [ $BKNAME = *.tar.gz ];then
               $TAR -zxvf $BKNAME -C $DST;
            fi
            ;;
            6)
            read -p "Please input the name of backup file" BACKUP_FILE
            read -p "Please input a md5 or sha1 value: " HASH
            if [ ${#HASH} -eq $MD5_LEN ];then
                md5_sum=$(md5sum $BACKUP_FILE | awk '{ print $1 }');
              if [ $HASH = $md5_sum ];then
                echo "Value matches!";
              else
                echo "Value doesn\'t match";
              fi
            
            elif [ ${#HASH} -eq $SHA1_LEN ];then
              sha1_sum=$(sha1sum $BACKUP_FILE | awk '{ print $1 }');
              if [ $HASH = $sha1_sum ];then
                echo "Value matches!";
              else
                echo "Value doesn\'t match";
              fi
            fi
                ;;
            7)


                ;;
            8)


                ;;

            9)


                ;;
            10)
                exit
                ;;
            \?) 
                $ECHO "Please type valid input."
                exit 1
                ;;
    esac
done

























#if [ "$INPUT" = "1" ]; then
   #TODO: need validation here
#    read -p "Please type the directory to be backed up: " $DIRECTORY
#elif [ "$INPUT" = "2" ]; then
#    $ECHO "Please select which files to backup"
#    $ECHO "a. Backup All."
#    $ECHO "b. Backup by selected Date"
#    read -p "Enter Choice: " INPUT
#    if [ "$INPUT" = "a" ];then
#        $FILESNAME=*.*
#    elif [ "$INPUT" = "b" ];then
#        read -p "Please type a date, we will only backup files that were last modified before it." DATE
#    fi
#elif [ "$INPUT" = "3" ];then
#    read -p "Please select your archive method" ARCMTD
#fi


