#!/bin/bash
# Secure Ssh

secure_ssh() {

    ssh_config="/etc/ssh/sshd_config"

    read -p "Do you want to secure SSH access? (y/n): " ssh_choice
    if [ "$ssh_choice" == "y" ]; then

        read -p "Do you want to change the default SSH port from 22? (y/n): " ssh_port_choice
        if [ "$ssh_port_choice" == "y" ]; then
            read -p "Enter the new SSH port (e.g., 2222): " ssh_port
            sed -i "/^#Port 22/c\\Port $ssh_port" $ssh_config
            ufw allow $ssh_port
        fi

        read -p "Do you want to disable root login over SSH? (y/n): " root_login_choice
        if [ "$root_login_choice" == "y" ]; then
            sed -i "/^#PermitRootLogin/c\\PermitRootLogin no" $ssh_config
        fi

        read -p "Do you want to allow only specific users to SSH? (y/n): " ssh_users_choice
        if [ "$ssh_users_choice" == "y" ]; then
            read -p "Enter the usernames allowed to SSH, separated by space: " ssh_users
            sed -i "/^#AllowUsers/d" $ssh_config
            echo "AllowUsers $ssh_users" >> $ssh_config
        fi

        read -p "Do you want to set up SSH key authentication and disable password authentication? (y/n): " ssh_key_choice
        if [ "$ssh_key_choice" == "y" ]; then
            sed -i "/^#PasswordAuthentication/c\\PasswordAuthentication no" $ssh_config
            echo "Ensure your SSH public key is added to the ~/.ssh/authorized_keys file of the user."
        fi

        systemctl restart ssh
        echo "SSH configuration updated."
    else
        echo "Skipping SSH security configuration."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    secure_ssh
fi
