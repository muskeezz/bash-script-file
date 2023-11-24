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
        echo "Checking Updats..."
        sudo apt update >> "$LOG_FILE" 2>&1
        if [ $? != 0 ] ; then
            echo "New Updates Available!"
        else
            echo "No Update!"
        fi
        ;;
    "fedora" | "rhel")
        log "$PRETTY_NAME UPDATING REPOSITORY..."
        sudo yum makecache >> "$LOG_FILE" 2>&1
        log "Checking new update..."
        echo "Checking Updats..."
        sudo yum check-update >> "$LOG_FILE" 2>&1
        if [ $? != 0 ] ; then
            echo "New Updates Available!"
        else
            echo "No Update!"
        fi
        ;;
    "centos")
        grep -Eowq '^mirrorlist|^#baseurl=http://mirror' /etc/yum.repos.d/CentOS-Linux-*
        if [ $? = 0 ]; then
        sudo sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
        sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
        fi
        log "$PRETTY_NAME UPDATING REPOSITORY..."
        sudo yum makecache >> "$LOG_FILE" 2>&1
        log "Checking new update..."
        echo "Checking Updates..."
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