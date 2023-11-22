#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)

case "$distro" in
    "ubuntu" | "debian")
        #sudo apt-get update
        sudo apt update > update.log 2>&1
        #sudo apt-get --simulate upgrade > upgrade.log 2>&1
        sudo apt list --upgradable > upgrade.log 2>&1
        echo "This will not run the upgrade. Please check upgrade.log"
        #sudo apt-get upgrade
        ;;
    "centos" | "fedora" | "rhel")
        sudo yum update
        ;;
    "opensuse" | "sles")
        sudo zypper refresh && sudo zypper update
        ;;
    *)
        echo "Unsupported distribution: $distro"
        ;;
esac
