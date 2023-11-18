#!/bin/bash
# Root privilege is required

# Disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo unlink /etc/resolv.conf

# Hard code the nameserver
sudo bash -c 'echo -e "nameserver 127.0.0.1\nnameserver 1.1.1.1\nnameserver 8.8.8.8" >/etc/resolv.conf'

# Install dnsmasq
sudo apt-get update
sudo apt-get install dnsmasq -y

# Configure dnsmasq
sudo mv -v /etc/dnsmasq.conf /etc/dnsmasq.conf.orig 2>/dev/null

l_interface=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $7}'`
subnet=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $2}'`
ip=`echo $subnet | awk -F '/' '{print $1}'`
sz=`echo $subnet | awk -F '/' '{print $2}'`
segment=`echo ${ip%.*}`
router=`ip route show | head -1 | awk '{print $3}'`

fileBIOS="netboot.xyz.kpxe"
fileUEFI="netboot.xyz.efi"

echo $l_interface
echo $subnet
echo $ip
echo $sz

sudo bash -c 'echo -e "interface='$l_interface'\nbind-interfaces\n\
domain=\n\
\n\
dhcp-range='$l_interface','$segment'.110,'$segment'.120,255.255.255.0,8h\n\
dhcp-option=option:router,'$router'\n\
dhcp-option=option:dns-server,1.1.1.1\n\
dhcp-option=option:dns-server,8.8.8.8\n\
\n\
dhcp-match=set:bios-x86,option:client-arch,0\n\
dhcp-boot=tag:bios-x86,'$fileBIOS'\n\
\n\
dhcp-match=set:efi-x86_64,option:client-arch,7\n\
dhcp-match=set:efi-x86_64,option:client-arch,9\n\
dhcp-boot=tag:efi-x86_64,'$fileUEFI'\n\
" > /etc/dnsmasq.conf'