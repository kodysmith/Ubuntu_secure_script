#!/bin/bash
# Configure Apparmor Profiles

configure_apparmor_profiles() {

    read -p "Do you want to enforce AppArmor profiles for applications? (y/n): " apparmor_profiles_choice
    if [ "$apparmor_profiles_choice" == "y" ]; then
        for profile in /etc/apparmor.d/*; do
            aa-enforce "$profile"
        done
        echo "AppArmor profiles enforced for applications."
    else
        echo "Skipping AppArmor profiles enforcement."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    configure_apparmor_profiles
fi
