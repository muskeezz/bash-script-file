#!/bin/bash

remote="10.10.10.78"
crushftp_path=$(ssh $remote find /var/opt/ -name Crush* | head -1 2> /dev/null)
backup_path="/home/andre/crushftp/backup"
user="andre"
remote_server="$user@$remote"
crushftp_service="$crushftp_path/crushftp_init.sh"

#dnf install rsync -y

ssh -t $remote_server "sudo $crushftp_service stop" 2> /dev/null

#below script not asking any password
rsync -azv -e ssh $remote:/$crushftp_path/users/MainUsers $backup_path
rsync -azv -e ssh $remote:/$crushftp_path/WebInterface/images/logo* $backup_path
rsync -azv -e ssh $remote:/$crushftp_path/WebInterface/favicon.ico $backup_path

#Start CrushFTP Service
ssh -t $remote_server "sudo $crushftp_service start && sleep 2" 2> /dev/null
