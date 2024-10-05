#!/bin/bash
# Setup 2fa

setup_2fa() {

    ssh_config="/etc/ssh/sshd_config"

    read -p "Do you want to set up Two-Factor Authentication for SSH? (y/n): " twofa_choice
    if [ "$twofa_choice" == "y" ]; then
        apt install -y libpam-google-authenticator
        read -p "Enter the username to configure 2FA for: " twofa_user
        su - "$twofa_user" -c "google-authenticator"
        echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd
        sed -i "/^#ChallengeResponseAuthentication/c\\ChallengeResponseAuthentication yes" $ssh_config
        systemctl restart ssh
        echo "2FA configured for SSH."
    else
        echo "Skipping 2FA setup."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    setup_2fa
fi
