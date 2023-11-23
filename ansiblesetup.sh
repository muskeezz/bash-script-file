#!/bin/bash
source /etc/os-release
LOG_FILE="ansible_install.log"

# Function to log messages
log() {
    timestamp=$(date +"%Y-%m-%d %T")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to install Ansible on Ubuntu/Debian
u_ansible() {
    log "Checking if Ansible is installed."
    if ! dpkg -l | grep -q '^ii.*ansible'; then
    log "Updating package lists..."
    sudo apt update >> "$LOG_FILE" 2>&1

    if ls /etc/apt/sources.list.d/ansible* 1> /dev/null 2>&1; then
        log "Ansible repository found. Installing Ansible..."
        sudo apt install ansible -y >> "$LOG_FILE" 2>&1
    else
        log "Adding Ansible repository..."
        sudo apt-add-repository ppa:ansible/ansible -y >> "$LOG_FILE" 2>&1
        log "Updating package lists after adding repository..."
        sudo apt update >> "$LOG_FILE" 2>&1
        log "Installing Ansible..."
        sudo apt install ansible -y >> "$LOG_FILE" 2>&1
    fi
    else
        log "Ansible is installed."
        exit 0
    fi
}

# Function to install Ansible on RHEL/CentOS/Fedora
r_ansible() {
    log "Installing Ansible on RHEL/CentOS/Fedora from EPEL repository..."
    sudo yum install -y epel-release >> "$LOG_FILE" 2>&1
    sudo yum install -y ansible >> "$LOG_FILE" 2>&1
}

case $ID in
    "ubuntu" | "debian")
        log "Detected $NAME. Installing Ansible for Debian-based system..."
        u_ansible
        if [ $? -eq 0 ]; then
            log "Ansible installation on $NAME completed successfully."
            echo "Ansible has been installed on $NAME."
        else
            log "Error installing Ansible on $NAME."
            echo "An error occurred while installing Ansible on $NAME. Check $LOG_FILE for details."
        fi
        ;;
    "centos" | "fedora" | "rhel")
        log "Detected $NAME. Installing Ansible for RHEL-based system..."
        r_ansible
        if [ $? -eq 0 ]; then
            log "Ansible installation on $NAME completed successfully."
            echo "Ansible has been installed on $NAME."
        else
            log "Error installing Ansible on $NAME."
            echo "An error occurred while installing Ansible on $NAME. Check $LOG_FILE for details."
        fi
        ;;
    *)
        log "$NAME is not yet configured"
        echo "$NAME is not yet configured"
        ;;
esac