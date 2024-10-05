#!/bin/bash
# Enable Auto Updates

enable_auto_updates() {

    read -p "Do you want to enable automatic security updates? (y/n): " auto_update_choice
    if [ "$auto_update_choice" == "y" ]; then
        apt install -y unattended-upgrades
        dpkg-reconfigure --priority=low unattended-upgrades
        echo "Automatic security updates enabled."
    else
        echo "Skipping automatic security updates."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    enable_auto_updates
fi
