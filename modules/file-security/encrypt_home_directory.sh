#!/bin/bash
# Encrypt Home Directory

encrypt_home_directory() {

    read -p "Do you want to encrypt your home directory? (y/n): " encrypt_home_choice
    if [ "$encrypt_home_choice" == "y" ]; then
        apt install -y ecryptfs-utils
        read -p "Enter the username whose home directory you want to encrypt: " encrypt_user
        ecryptfs-migrate-home -u "$encrypt_user"
        echo "Home directory encryption initiated for $encrypt_user. Please log out and log back in."
    else
        echo "Skipping home directory encryption."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    encrypt_home_directory
fi
