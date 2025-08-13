#!/bin/sh
[ -d /proc/sys/net/ipv4/conf/tun0 ] && echo "VPN $({ ip -4 -br a sh dev tun0 | awk {'print $3'} | cut -f1 -d/; } 2>/dev/null)"
