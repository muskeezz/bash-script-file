#!/bin/bash
# Variables
remote="andre@10.10.10.187"
conf_path="/var/opt/CrushFTP10"
data_path="/media/Logs"

OPT_EXCLUDE="-zv --exclude lost+found --exclude admin"
LOGFILE="$HOME/crushftp/ftp-backup.log"

#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/users/MainUsers $conf_path/users/MainUsers &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/images $conf_path/WebInterface/images &> $LOGFILE
rsync $OPT_EXCLUDE -e ssh $remote:/$conf_path/WebInterface/favicon* $conf_path/WebInterface &> $LOGFILE
#rsync $OPT_EXCLUDE -e ssh $remote:/$data_path $data_path &> $LOGFILE