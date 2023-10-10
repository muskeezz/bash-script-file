#!/bin/bash

########################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v2
#########################

<< 'EOF'

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