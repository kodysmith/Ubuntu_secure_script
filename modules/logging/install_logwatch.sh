#!/bin/bash
# Install Logwatch

install_logwatch() {

    read -p "Do you want to install Logwatch for log monitoring? (y/n): " logwatch_choice
    if [ "$logwatch_choice" == "y" ]; then
        apt install -y logwatch
        echo "Logwatch installed. Configure /usr/share/logwatch/default.conf/logwatch.conf as needed."
    else
        echo "Skipping Logwatch installation."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    install_logwatch
fi
