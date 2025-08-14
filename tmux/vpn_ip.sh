#!/bin/bash

if [ -d /proc/sys/net/ipv4/conf/tun0 ]; then
    VPN_INTERFACE=$(ip -4 -br a show dev tun0 2>/dev/null | awk '{print $3}' | cut -d/ -f1)
    if [ -n "$VPN_INTERFACE" ]; then
        echo " VPN $VPN_INTERFACE "
    fi
fi
