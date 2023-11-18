#!/bin/bash

##################################
# Author: Andre Manatad
# Date: 07/10/2023
#
# CrushFTP10 Backup Script
#
# Version: v5
##################################
#!/bin/bash

#Variable Array
USER="andre"
REMOTE="10.10.10.187"
SOURCE=("/var/opt/CrushFTP10/users/MainUsers" "/var/opt/CrushFTP10/WebInterface/images" "/var/opt/CrushFTP10/WebInterface/favicon.ico" "/media/Logs")
# If LOGFILE directory not found this will create a directory
#[ ! -d ${LOGDIR} ] && $(mkdir -p ${LOGDIR})
#LOGDIR="$HOME/crushftp/backup/log/$LOGFILE"
#LOGFILE="$(date +%d%b%Y )-file.log"

#

#Test
#echo "Text inside the log file" > $LOGFILE

#Backup function
backup(){
	local FILES=("$@")
	for B_SOURCE in "${FILES[@]}"; do
	local B_DESTINATION=${B_SOURCE%/*}
  local LOGLINE="__________________________________________________________________________"  

  echo -e "$B_SOURCE -> $B_DESTINATION\n$LOGLINE\n\n\
  $(rsync -avz --exclude={'lost+found','admin'} -e ssh $USER@$REMOTE:$B_SOURCE $B_DESTINATION --stats)\n$LOGLINE"
  
  done
}

backup "${SOURCE[@]}"