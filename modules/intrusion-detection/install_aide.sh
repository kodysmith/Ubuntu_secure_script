#!/bin/bash
# Install Aide

install_aide() {

    read -p "Do you want to install AIDE for intrusion detection? (y/n): " aide_choice
    if [ "$aide_choice" == "y" ]; then
        apt install -y aide
        aideinit
        mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
        echo "AIDE installed and initialized."
    else
        echo "Skipping AIDE installation."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    install_aide
fi
