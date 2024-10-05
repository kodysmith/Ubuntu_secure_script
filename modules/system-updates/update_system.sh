#!/bin/bash
# Update System

update_system() {

    read -p "Do you want to update and upgrade your system packages? (y/n): " update_choice
    if [ "$update_choice" == "y" ]; then
        apt update && apt upgrade -y
        echo "System packages updated."
    else
        echo "Skipping system update."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    update_system
fi
