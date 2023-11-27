#!/usr/bin/env bash
source /etc/os-release
[ ! "ID" = "centos" ] echo exit 1
LOG_FILE="$0.log"
log() {
    timestamp=$(date +'%Y-%m-%d %T')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}
# check if python is installed
[[ $(rpm -qa | grep '^python38') ]] && echo "Python 3.8 already installed!" && exit 0

# install python
log "Installing Python 3.8..."
echo "Installing Python 3.8..."
sudo yum install python3.8 -y >> "$LOG_FILE" 2>&1
sudo alternatives --set python /usr/bin/python3
log "Python 3.8 Succesfully Installed!"
echo "Python 3.8 Succesfully Installed!"