#!/bin/bash

# Disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo unlink /etc/resolv.conf

# Hard code the nameserver
nm1="1.1.1.1"
nm2="8.8.8.8"
echo "nameserver 127.0.0.1\nnameserver $nm1\nnameserver $nm2" >~/resolv.conf

# Install dnsmasq
sudo apt-get update
sudo apt-get install dnsmasq -y

# Configure dnsmasq
[ ! -e /etc/dnsmasq.conf.orig] && mv -v /etc/dnsmasq.conf /etc/dnsmasq.conf.orig 2>/dev/null

interface=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $7}'`
ip=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $2}' | awk -F '/' '{print $1}'`
segment=`echo ${ip%.*}`
router=`ip route show | head -1 | awk '{print $3}'`
netboot="192.168.18.200"            
fileBIOS="netboot.xyz.kpxe"
fileUEFI="netboot.xyz.efi"

echo "port=0\ninterface=$interface\nbind-dynamic\n\
log-dhcp\ndhcp-authoritative\n\
dhcp-range=$segment.2,$segment.254,255.255.255.0,8h\n\
dhcp-option=option:router,$router\n\
dhcp-option=option:dns-server,$nm1\n\
dhcp-option=option:dns-server,$nm2\n\
dhcp-match=set:bios,option:client-arch,0\n\
dhcp-match=set:efi-i32,option:client-arch,2\n\
dhcp-match=set:efi-i32,option:client-arch,6\n\
dhcp-match=set:efi-i64,option:client-arch,7\n\
dhcp-match=set:efi-i64,option:client-arch,8\n\
dhcp-match=set:efi-i64,option:client-arch,9\n\
dhcp-match=set:efi-a32,option:client-arch,10\n\
dhcp-match=set:efi-a64,option:client-arch,11\n\
dhcp-boot=tag:bios,$fileBIOS,,$netboot\n\
dhcp-boot=tag:!bios,$fileUEFI,,$netboot" > ~/dnsmasq.conf

chmod 644 ~/dnsmasq.conf ~/resolv.conf
sudo chown root:root ~/dnsmasq.conf ~/resolv.conf
sudo mv -v ~/dnsmasq.conf ~/resolv.conf /etc/

sudo systemctl restart dnsmasq
sudo systemctl enable dnsmasq