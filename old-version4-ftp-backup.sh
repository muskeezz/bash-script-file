#!/bin/bash

########################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v2
#########################

<< EOF

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

# Version: v3

#Function
backup(){
echo -e "`date '+%Y-%b-%m %I:%M %p'` | $1 \n---------------------------------------------\n`\
rsync -avzn --exclude={'lost+found','admin'} andre@10.10.10.187:$1 $1 --stats | \
sed '0,/^$/d'`\nFinish: `date '+%Y-%b-%m %I:%M %p'` \n---------------------------------------------\n\n`\
head -n 2000 $HOME/bash-script-file/ftp.log`" > $HOME/bash-script-file/ftp.log
}

backup /var/opt/CrushFTP10/users/MainUsers
backup /var/opt/CrushFTP10/WebInterface/images
backup /var/opt/CrushFTP10/WebInterface/favicon.ico
backup /media/Logs

EOF

# Version: v4
#Variable Data
BACKUP1="/var/opt/CrushFTP10/users/MainUsers"
BACKUP2="/var/opt/CrushFTP10/WebInterface/images"
BACKUP3="/var/opt/CrushFTP10/WebInterface/favicon.ico"
BACKUP4="/media/Logs"
USER="andre"
REMOTE="10.10.10.187"

#Variable Logfile
LOGFILE="$HOME/bash-script-file/ftp.log"
STARTTIME=`date '+%d.%m.%y %H:%M'`
START=`date +%s`
THISLOGHEAD=" __________________________________________________\n\
|\n\
| Script: $0\n\
| Hostname: `hostname`\n\
| Started: $STARTTIME\n"
LOGCONTENT="`head -n 2000 $LOGFILE`"
THISLOG=""
SUMMARY=""

#Function
backup(){
local FSTARTTIME="`date '+%H:%M'`"
local FSTART=`date +%s`
echo -e "$THISLOGHEAD|\n\n\
------------------------------------------------------------\n\
| Summary:\n\
------------------------------------------------------------\n\
$SUMMARY\n\
`date '+%H:%M'`-now: $1 -> $2\n\n\
------------------------------------------------------------\n\
| Details:\n\
------------------------------------------------------------\n\
$THISLOG\n$LOGCONTENT" > $LOGFILE
THISLOG="$THISLOG\n$STARTTIME | $1 \n->$2\n------------------------------------------------------------\n\
`rsync -avzn --exclude={'lost+found','admin'} -e ssh $USER@$REMOTE:$1 $2 --stats | sed '0,/^$/d'`\n\
Finished: $STARTTIME \n------------------------------------------------------------\n\n"
echo -e "$THISLOGHEAD\n$THISLOG\n$THISLOGCONTENT" > $LOGFILE
local FSECONDS="$((`date +%s` -$FSTART))"
SUMMARY="$SUMMARY \n$FSTARTTIME-`date '+%H:%M'` (`date -d@$FSECONDS -u +%H:%M:%S`): $1 -> $2"
}

backup $BACKUP1 $BACKUP1
backup $BACKUP2 $BACKUP2
backup $BACKUP3 $BACKUP3
backup $BACKUP4 $BACKUP4

# Summary Output
SECONDS="$((`date +%s`-$START))"
echo -e "$THISLOGHEAD\
| Finished: `date '+%d.%m.%y %H:%M'`\n\
| Runtime: `date -d@$SECONDS -u +%H:%M:%S`\n|\n\n\
 ------------------------------------------------------------\n\
| Summary:\n\
 ------------------------------------------------------------\n\
$SUMMARY\n\n
 ------------------------------------------------------------\n\
| Details:\n\
 ------------------------------------------------------------\n\
$THISLOG\n\
|__________________________________________________\n\
$LOGCONTENT" > $LOGFILE