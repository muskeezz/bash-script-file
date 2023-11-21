#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)

case "$distro" in
    "ubuntu" | "debian")
        sudo apt update && sudo apt upgrade
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
