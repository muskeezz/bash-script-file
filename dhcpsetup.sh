#!/bin/bash
# This scrip works on ubuntu 20.04
# imported os_update

#./os_update.sh &
#wait

# Disable systemd-resolved and Hard code the nameserver
[ -L /etc/resolv.conf ] && sudo systemctl stop systemd-resolved\
&& sudo systemctl disable systemd-resolved\
&& sudo unlink /etc/resolv.conf\
&& echo "nameserver 127.0.0.53\nnameserver 8.8.8.8\nnameserver 1.1.1.1" >~/resolv.conf\
&& chmod 644 ~/resolv.conf\
&& sudo chown root:root ~/resolv.conf\
&& sudo mv -v ~/resolv.conf /etc/

# Install dnsmasq
[ $(sudo apt list --installed | grep -w dnsmasq | wc -l) -le 1 ] && sudo apt install dnsmasq -y

interface=$(ip a | grep -Ev 'dynamic|host' | grep -w 'inet' | head -1 | awk '{print $7}')
ip=$(ip a | grep -Ev 'dynamic|host' | grep -w 'inet' | head -1 | awk '{print $2}' | awk -F '/' '{print $1}')
segment=$(echo ${ip%.*})
router=$(ip route show | head -1 | awk '{print $3}')
netboot="$ip"         # PXE boot host is itself   
fileBIOS="netboot.xyz.kpxe"
fileUEFI="netboot.xyz.efi"

echo "port=0\ninterface=$interface\nbind-dynamic\n\
log-dhcp\ndhcp-authoritative\n\
dhcp-range=$segment.2,$segment.254,255.255.255.0,8h\n\
dhcp-option=option:router,$router\n\
dhcp-option=option:dns-server,8.8.8.8\n\
dhcp-option=option:dns-server,1.1.1.1\n\
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

# Configure dnsmasq, dnsmasq log can be read at /var/log/syslog
#[ ! -e /etc/dnsmasq.conf.orig ] && sudo mv -v /etc/dnsmasq.conf /etc/dnsmasq.conf.orig 2>/dev/null
chmod 644 ~/dnsmasq.conf
sudo chown root:root ~/dnsmasq.conf
sudo mv -v ~/dnsmasq.conf /etc/dnsmasq.d/

sudo systemctl restart dnsmasq
[ $(sudo systemctl is-enabled dnsmasq) != enabled ] && sudo systemctl enable dnsmasq