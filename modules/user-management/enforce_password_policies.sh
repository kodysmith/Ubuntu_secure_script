#!/bin/bash
# Enforce Password Policies

enforce_password_policies() {

    read -p "Do you want to enforce strong password policies? (y/n): " password_policy_choice
    if [ "$password_policy_choice" == "y" ]; then
        apt install -y libpam-pwquality
        sed -i '/pam_pwquality.so/d' /etc/pam.d/common-password
        echo "password requisite pam_pwquality.so retry=3 minlen=12 difok=3" >> /etc/pam.d/common-password
        echo "Password policies enforced."
    else
        echo "Skipping password policy enforcement."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    enforce_password_policies
fi
