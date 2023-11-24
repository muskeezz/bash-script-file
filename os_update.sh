#!/usr/bin/env bash

# Funtion logging
LOG_FILE="update.log"
log() {
    timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Main Script
source /etc/os-release
case "$ID" in
    "ubuntu" | "debian")
        log "$PRETTY_NAME UPDATING..."
        sudo apt update >> "$LOG_FILE" 2>&1
        ;;
    "centos" | "fedora" | "rhel")
        sudo yum update
        ;;
    "opensuse" | "sles")
        sudo zypper refresh && sudo zypper update
        ;;
    *)
        echo "Unsupported distribution: $ID"
        ;;
esac