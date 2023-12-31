#!/bin/bash
# This script is to register your RHEL on Red Hat Subscription Manager
source /etc/os-release

[ ! "$ID" = "rhel" ] && echo "This Script Support ONLY RHEL OS" && exit 1

echo "Login your Red Hat Customer Portal Account"
read -p "Enter Username: " _user
read -p "Enter Password: " -s _pass
echo -e "\n"
sudo subscription-manager register --username $_user --password $_pass --auto-attach
sudo subscription-manager list | grep -E "Starts|Ends"