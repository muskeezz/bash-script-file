#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)

case "$distro" in
    "ubuntu" | "debian")
        sudo apt update && sudo apt upgrade -y
        ;;
    "centos" | "fedora" | "rhel")
        sudo yum update -y
        ;;
    "opensuse" | "sles")
        sudo zypper refresh && sudo zypper update -y
        ;;
    *)
        echo "Unsupported distribution: $distro"
        ;;
esac