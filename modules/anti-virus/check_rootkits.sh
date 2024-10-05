#!/bin/bash
# Check Rootkits

check_rootkits() {

    read -p "Do you want to install and run rkhunter to check for rootkits? (y/n): " rkhunter_choice
    if [ "$rkhunter_choice" == "y" ]; then
        apt install -y rkhunter
        rkhunter --update
        rkhunter --checkall
        echo "Rootkit check completed."
    else
        echo "Skipping rootkit check."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    check_rootkits
fi
