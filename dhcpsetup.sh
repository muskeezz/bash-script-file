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
sudo apt-get install dnsmasq-y

# Configure dnsmasq
sudo mv -v /etc/dnsmasq.conf /etc/dnsmasq.conf.orig 2>/dev/null

l_interface=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $7}'`
subnet=`ip a | grep -w 'inet' | grep -v 'dynamic' | tail -1 | awk '{print $2}'`
ip=`echo $subnet | awk -F '/' '{print $1}'`
sz=`echo $subnet | awk -F '/' '{print $2}'`

#sudo bash -c 'echo -e "interface=$l_interface\n\
bind-interfaces\n\
domain=\n\
\n
dhcp-range=$l_interface,$
