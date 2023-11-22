#!/bin/bash

cleanup(){
    rm -f .lock
    rm -f update-*.log
    rm -f dpkg-installed-*.log
    rm -f upgrade-*.log
}
trap cleanup EXIT
_lock=".lock"
[ -f .lock ] && exit 0 || touch "$_lock"

check_new_kernel(){
#    local latest_kernel=$(apt list --upgradable 2>/dev/null | grep -oP 'linux-image-\d+\.\d+\.\d+-\d+' | sort -V | tail -1)
#    local current_kernel=$(uname -r)
    local new_kernel=$(sudo apt list --upgradable | grep linux-image | wc -l)

    if [[ $new_kernel -eq 0 ]]; then
        #echo "A new kernel version ($latest_kernel) is available for upgrade."
        echo "A new kernel version is available for upgrade."
    fi
}
check_new_package(){
    sudo apt update
    local upgrade=$(sudo apt list --upgradable | wc -l)
    if [[ $upgrade -gt 1 ]]; then
        sudo dpkg -l > dpkg-installed-$(date '+%Y%m%d').log 2>&1
        sudo apt list --upgradable > upgrade-$(date '+%Y%m%d').log 2>&1
        echo "New Package available. Please see upgrade-$(date '+%Y%m%d').log"
    fi
}

distro=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)

case "$distro" in
    "ubuntu" | "debian")
        check_new_package
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

#rm -f "$_lock"