#!/bin/bash

#Command 
ECHO='/bin/echo'
ZIP='/usr/bin/zip'
TAR='/bin/tar'
UNZIP='/usr/bin/unzip'
FIND='/usr/bin/find'
#Variable
INPUT=
INPUT2=
DIRECTORY=
FILESNAME=
DATE=
ARCMTD=
BKNAME=
BACKUP_FILE=
HASH=
MD5_SUM=
SHA1_SUM=
DST=
FILE_TYPE=NULL

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
                FILENAME=$($FIND $DIRECTORY ! -newermt $DATE)
            fi
            
            if [ $ARCMTD = "zip" ] && [ $INPUT2 = "a" ];then
                $ZIP -j "$USER-backup" $DIRECTORY/$FILENAME;
            elif [ "$ARCMTD" = "zip" ] && [ "$INPUT2" = "b" ];then
                $ZIP -j "$USER-backup" $FILENAME;
            fi

            set -x
            if [ "$ARCMTD" = "tar" ] && [ "$INPUT2" = "a" ];then
                $TAR -C $DIRECTORY -cvzf "$USER-backup.tar" $FILENAME;
            elif [ "$ARCMTD" = "tar" ] && [ "$INPUT2" = "b" ];then
                $TAR -C $DIRECTORY -cvzf "$USER-backup.tar" $FILENAME;
            fi

            if [ "$ARCMTD" = "tgz" ] && [ "$INPUT2" = "a" ];then
                $TAR -C $DIRECTORY -cvzf "$USER-backup.tar.gz" $FILENAME;
            elif [ "$ARCMTD" = "tgz" ] && [ "$INPUT2" = "b" ];then
                $TAR -C $DIRECTORY -cvzf "$USER-backup.tar.gz" $FILENAME
            fi 
            set +x
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
                MD5_SUM=$(md5sum $BACKUP_FILE | awk '{ print $1 }');
              if [ $HASH = $MD5_SUM ];then
                $ECHO "Value matches!";
              else
                $ECHO "Value doesn\'t match";
              fi
            
            elif [ ${#HASH} -eq $SHA1_LEN ];then
              SHA1_SUM=$(sha1sum $BACKUP_FILE | awk '{ print $1 }');
              if [ $HASH = $SHA1_SUM ];then
                $ECHO "Value matches!";
              else
                $ECHO "Value doesn\'t match";
              fi
            fi
                ;;
            7)
                read -p "Please input the backup file: " BKNAME
                read -p "Please input the pattern: " PATTERN

                file $BKNAME | grep Zip > /dev/null 2>&1
                if [ $? -eq 0 ];then
                  FILE_TYPE='zip'
                fi

                if [ $FILE_TYPE = 'zip' ];then
                   FILES=$(unzip -l $BKNAME | awk '{ if (NR >= 4 && $4 != "") { print $4; } }')
                   grep $PATTERN $BKNAME > /dev/null 2>&1  
                   if [ $? -eq 0 ];then
                     $ECHO "Matched"   
                   else
                     $ECHO "Unmatched"
                   fi
                fi
                file $BKNAME | grep -i gzip > /dev/null 2>&1
                if [ $? -eq 0 ];then
                    FILE_TYPE='tar'
                fi
                
                if [ $FILE_TYPE = 'tar' ];then
                    zgrep $PATTERN $BKNAME
                    if [ $? -ne 0 ];then
                        $ECHO "Unmatched"
                    fi
                fi
                            
                ;;
            8)
                read -p "Please input the backup filename: " FILENAME
                read -p "Please input the output filename: " OUTPUT
                openssl aes-256-cbc -a -salt -in $FILENAME -out $OUTPUT 
                
                ;;

            9)
                read -p "Please input the encrypted backup filename: " FILENAME
                read -p "Please input the output filename: " OUTPUT
                openssl aes-256-cbc -a -d -in $FILENAME -out $OUTPUT 
                ;;
            10)
                echo Bye
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


