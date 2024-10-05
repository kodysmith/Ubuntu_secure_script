#!/bin/bash
# Install Antivirus

install_antivirus() {

    read -p "Do you want to install ClamAV antivirus software? (y/n): " clamav_choice
    if [ "$clamav_choice" == "y" ]; then
        apt install -y clamav clamav-daemon
        freshclam
        echo "ClamAV installed and updated."
    else
        echo "Skipping ClamAV installation."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    install_antivirus
fi
