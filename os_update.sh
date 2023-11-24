#!/usr/bin/env bash

# Funtion logging
LOG_FILE="$0.log"
log() {
    timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Main Script
source /etc/os-release
case "$ID" in
    "ubuntu" | "debian")
        log "$PRETTY_NAME UPDATING REPOSITORY..."
        sudo apt update >> "$LOG_FILE" 2>&1
        if [ $? != 0 ] ; then
            echo "New Updates Available!"
        else
            echo "No Update!"
        fi
        ;;
    "centos" | "fedora" | "rhel")
        log "$PRETTY_NAME UPDATING REPOSITORY..."
        sudo yum makecache >> "$LOG_FILE" 2>&1
        log "Checking new update..."
        sudo yum check-update >> "$LOG_FILE" 2>&1
        if [ $? != 0 ] ; then
            echo "New Updates Available!"
        else
            echo "No Update!"
        fi
        ;;
    *)
        echo "Unsupported distribution: $ID"
        ;;
esac