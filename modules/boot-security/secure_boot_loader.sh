#!/bin/bash
# Secure Boot Loader

secure_boot_loader() {

    grub_cfg="/etc/grub.d/40_custom"

    read -p "Do you want to set a GRUB password to secure the boot loader? (y/n): " grub_choice
    if [ "$grub_choice" == "y" ]; then
        read -p "Enter the GRUB username: " grub_user
        read -s -p "Enter the GRUB password: " grub_pass
        echo
        hashed_pass=$(echo -e "$grub_pass\\n$grub_pass" | grub-mkpasswd-pbkdf2 | grep "grub.pbkdf2" | awk '{print $7}')
        echo "set superusers=\\"$grub_user\\"" >> $grub_cfg
        echo "password_pbkdf2 $grub_user $hashed_pass" >> $grub_cfg
        update-grub
        echo "GRUB password set."
    else
        echo "Skipping GRUB password setup."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    secure_boot_loader
fi
