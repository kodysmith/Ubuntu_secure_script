#!/bin/bash
# Secure Network Settings

secure_network_settings() {

    sysctl_conf="/etc/sysctl.conf"

    read -p "Do you want to disable IPv6? (y/n): " ipv6_choice
    if [ "$ipv6_choice" == "y" ]; then
        sed -i "/disable_ipv6/d" $sysctl_conf
        echo "net.ipv6.conf.all.disable_ipv6 = 1" >> $sysctl_conf
        echo "net.ipv6.conf.default.disable_ipv6 = 1" >> $sysctl_conf
        sysctl -p
        echo "IPv6 disabled."
    else
        echo "Skipping IPv6 disablement."
    fi

    read -p "Do you want to configure sysctl for network protection? (y/n): " sysctl_choice
    if [ "$sysctl_choice" == "y" ]; then
        echo "
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_timestamps = 0
" >> $sysctl_conf
        sysctl -p
        echo "Network settings secured."
    else
        echo "Skipping sysctl network configuration."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    secure_network_settings
fi
