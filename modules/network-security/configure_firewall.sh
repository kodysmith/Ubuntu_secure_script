#!/bin/bash
# Configure Firewall

configure_firewall() {

    read -p "Do you want to enable UFW (Uncomplicated Firewall)? (y/n): " ufw_choice
    if [ "$ufw_choice" == "y" ]; then
        ufw enable
        read -p "Enter services to allow through the firewall (e.g., ssh http https), separated by space: " services
        for service in $services; do
            ufw allow $service
        done
        ufw status verbose
        echo "Firewall configured."
    else
        echo "Skipping firewall configuration."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    configure_firewall
fi
