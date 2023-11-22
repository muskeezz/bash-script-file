#!/bin/bash

cleanup(){
    rm -f $_lock
    rm -f $dpkglog
    rm -f $upgradelog
}
trap cleanup EXIT

_lock=".lock"
[ -f .lock ] && exit 0 || touch "$_lock"

upgradelog="upgrade.log"
dpkglog="dpkg-installed.log"

check_new_kernel(){
    local new_kernel=$(sudo apt list --upgradable | grep linux-image | wc -l)
    if [ $new_kernel != 0 ]; then
        #echo "A new kernel version ($latest_kernel) is available for upgrade."
        echo "A new kernel version is available for upgrade."
    fi
}
check_new_package(){
    sudo apt update
    local upgrade=$(sudo apt list --upgradable | wc -l)
    if [ $upgrade -gt 1 ]; then
        sudo dpkg -l > $dpkglog
        sudo apt list --upgradable > $upgradelog
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