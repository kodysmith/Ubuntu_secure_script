#!/bin/bash
# Limit User Privileges

limit_user_privileges() {

    read -p "Do you want to review user accounts and limit privileges? (y/n): " user_privileges_choice
    if [ "$user_privileges_choice" == "y" ]; then
        echo "Current user accounts:"
        awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd
        read -p "Enter the usernames you want to remove, separated by space: " users_remove
        for user in $users_remove; do
            deluser "$user"
            echo "User $user removed."
        done
        echo "User privileges updated."
    else
        echo "Skipping user privileges configuration."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    limit_user_privileges
fi
