#!/bin/bash

cleanup(){
    rm -f .lock
    rm -f update-*.log
    rm -f installed-package-*.log
    rm -f dpkg-installed-*.log
    rm -f upgrade-*.log
}
_lock=".lock"
[ -f .lock ] && exit 0 || touch "$_lock"

check_new_kernel(){
    local latest_kernel=$(apt list --upgradable 2>/dev/null | grep -oP 'linux-image-\d+\.\d+\.\d+-\d+' | sort -V | tail -1)
    local current_kernel=$(uname -r)
    if [[ $latest_kernel > $current_kernel ]]; then
        echo "A new kernel version ($latest_kernel) is available for upgrade."
    fi
}

distro=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)

case "$distro" in
    "ubuntu" | "debian")
        sudo apt update > update-$(date '+%Y%m%d').log 2>&1
        sudo apt list --installed > installed-package-$(date '+%Y%m%d').log 2>&1
        sudo dpkg -l > dpkg-installed-$(date '+%Y%m%d').log 2>&1
        sudo apt list --upgradable > upgrade-$(date '+%Y%m%d').log 2>&1
        echo "New Package available. Please see upgrade-$(date '+%Y%m%d').log"
        check_new_kernel
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

rm -f "$_lock"