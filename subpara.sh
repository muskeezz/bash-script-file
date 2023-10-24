#!/bin/bash

#Variable Array
USER="andre"
REMOTE="10.10.10.187"
SOURCE=("/var/opt/CrushFTP10/users/MainUsers" "/var/opt/CrushFTP10/WebInterface/images" "/var/opt/CrushFTP10/WebInterface/favicon.ico" "/media/Logs")
# If LOGFILE directory not found this will create a directory
LOGFILE="/var/ftp/ftp.log"
[ ! -d ${LOGFILE%/*} ] && $(mkdir ${LOGFILE%/*})
#

#Backup function
backup(){
	local FILES=("$@")
	for B_SOURCE in "${FILES[@]}"; do
	local B_DESTINATION=${B_SOURCE%/*}
	echo "$(rsync -avz --exclude={'lost+found','admin'} -e ssh $USER@$REMOTE:$B_SOURCE $B_DESTINATION --stats |& tee -a $LOGFILE)"
	done
}

backup "${SOURCE[@]}"