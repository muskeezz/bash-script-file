#!/usr/bin/env bash
source /etc/os-release
case "$ID" in
    "ubuntu" | "debian")
        echo "$ID"
        ;;
    "centos" | "fedora" | "rhel")
        echo "$ID"
        ;;
    *)
        echo "Unsupported distribution: $ID"
        ;;
esac