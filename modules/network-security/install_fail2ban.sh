#!/bin/bash
# Install Fail2ban

install_fail2ban() {

    read -p "Do you want to install and configure Fail2Ban? (y/n): " fail2ban_choice
    if [ "$fail2ban_choice" == "y" ]; then
        apt install -y fail2ban
        if [ ! -f /etc/fail2ban/jail.local ]; then
            cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
        fi
        echo "Fail2Ban installed with default configuration."
        systemctl restart fail2ban
    else
        echo "Skipping Fail2Ban installation."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    install_fail2ban
fi
