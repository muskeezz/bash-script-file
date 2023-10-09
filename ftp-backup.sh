#!/bin/bash

########################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v2
#########################
# Variables
#remote="andre@10.10.10.187"
#conf_path="/var/opt/CrushFTP10"
#data_path="/media/Logs"

#OPT_EXCLUDE="-zv --exclude lost+found --exclude admin"
#LOGFILE="$HOME/crushftp/ftp-backup.log"

#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/users/MainUsers $conf_path/users/MainUsers &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/images $conf_path/WebInterface/images &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/favicon* $conf_path/WebInterface &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$data_path $data_path &> $LOGFILE

echo -e "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/users/MainUsers \n`rsync -zvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/users/MainUsers /var/opt/CrushFTP10/users/MainUsers --stats | sed '0,/^$/d'` \nfinish `date '+%Y%m%d %H%M'` \n`head -n 2000 ./ftp.log`" > ftp.log
printf "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/WebInterface/images `rsync -zvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/WebInterface/images /var/opt/CrushFTP10/WebInterface/images --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log
printf "`date '+%Y%m%d %H%M'` /var/opt/CrushFTP10/WebInterface/favicon.ico `rsync -zvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/var/opt/CrushFTP10/WebInterface/favicon.ico /var/opt/CrushFTP10/WebInterface/ --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log
printf "`date '+%Y%m%d %H%M'` /media/Logs `rsync -zvn --exclude=lost+found --exclude=admin andre@10.10.10.187:/media/Logs /media/Logs --stats | sed '0,/^$/d'` finish `date '+%Y%m%d %H%M'` \n\n`head -n 2000 ./ftp.log`" > ftp.log
