#!/bin/bash

########################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v2
#########################

<<EOF

# Version: v1
# Variables
#remote="andre@10.10.10.187"
#conf_path="/var/opt/CrushFTP10"
#data_path="/media/Logs"

#OPT_EXCLUDE="-avz --exclude lost+found --exclude admin"
#LOGFILE="$HOME/crushftp/ftp-backup.log"


#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/users/MainUsers $conf_path/users/MainUsers &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/images $conf_path/WebInterface/images &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/favicon* $conf_path/WebInterface &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$data_path $data_path &> $LOGFILE

# Version: v2
#echo -e "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/users/MainUsers \n`rsync -azvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/users/MainUsers /var/opt/CrushFTP10/users/MainUsers --stats | sed '0,/^$/d'` \nfinish `date '+%Y%m%d %H%M'` \n`head -n 2000 ./ftp.log`" > ftp.log
#printf "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/WebInterface/images `rsync -azvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/WebInterface/images /var/opt/CrushFTP10/WebInterface/images --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log
#printf "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/WebInterface/favicon.ico `rsync -azvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/WebInterface/favicon.ico /var/opt/CrushFTP10/WebInterface/ --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log
#printf "`date '+%Y%m%d %H%M'` /media/Logs `rsync -azvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/media/Logs /media/Logs --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log

EOF

# Version: v3
#Variable

USER="andre"
REMOTE="10.10.10.187"
REMOTE_SERVER="$USER@REMOTE"
DATE=`date '+%d%m%Y'`
DATE_TIME="DATE: `date '+%Y-%b-%m'` TIME: `date '+%I:%M %p'`"
BACKUP1="/var/opt/CrushFTP10/users/MainUsers"
BACKUP2="/var/opt/CrushFTP10/WebInterface/images
BACKUP3="/var/opt/CrushFTP10/WebInterface/favicon.ico"
BACKUP4="/media/Logs"
OPT_EXCLUDE="-avzn --exclude={'lost+found','admin'}"

#Function

backup(){
echo -e "$DATE_TIME | $1 \n---------------------------------------------\n\
`rsync $OPT_EXCLUDE $REMOTE_SERVER:$1 $1 --stats | sed '0,/^$/d'`\n\
Finish: $DATE_TIME \n---------------------------------------------\n\n\
`head -n 2000 $HOME/crushftp/log/$DATE-ftp.log`" > $HOME/crushftp/log/$DATE-ftp.log
}

backup $BACKUP1

