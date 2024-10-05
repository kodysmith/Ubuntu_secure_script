#!/bin/bash
# Enable Apparmor

enable_apparmor() {

    read -p "Do you want to ensure AppArmor is enabled and enforce profiles? (y/n): " apparmor_choice
    if [ "$apparmor_choice" == "y" ]; then
        apparmor_status
        echo "Ensuring all profiles are in enforce mode..."
        for profile in /etc/apparmor.d/*; do
            aa-enforce "$profile"
        done
        echo "AppArmor profiles enforced."
    else
        echo "Skipping AppArmor configuration."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    enable_apparmor
fi
