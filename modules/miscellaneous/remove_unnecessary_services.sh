#!/bin/bash
# Remove Unnecessary Services

remove_unnecessary_services() {

    read -p "Do you want to list all services to identify unnecessary ones? (y/n): " services_list_choice
    if [ "$services_list_choice" == "y" ]; then
        systemctl list-unit-files --type=service
        read -p "Enter the names of services you want to disable, separated by space: " services_disable
        for service in $services_disable; do
            systemctl disable $service
            echo "Service $service disabled."
        done
    else
        echo "Skipping service review."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    remove_unnecessary_services
fi
