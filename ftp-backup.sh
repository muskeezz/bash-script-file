#!/bin/bash

##################################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v4.1
##################################

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
THISLOGHEAD=" ____________________________________________________________\n\
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
`rsync -avzn --exclude={'lost+found','admin'} -e ssh $USER@$REMOTE:$1 $2 | sed '0,/^$/d'`\n\
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
|____________________________________________________________\n\
 ------------------------------------------------------------
$LOGCONTENT" > $LOGFILE