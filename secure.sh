#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Please run 'sudo ./secure_ubuntu.sh'"
   exit 1
fi

echo "Welcome to the Ubuntu Security Configuration Script!"

# Step 1: Keep Your System Updated
read -p "Do you want to update and upgrade your system packages? (y/n): " update_choice
if [ "$update_choice" == "y" ]; then
    apt update && apt upgrade -y
    echo "System packages updated."
else
    echo "Skipping system update."
fi

read -p "Do you want to enable automatic security updates? (y/n): " auto_update_choice
if [ "$auto_update_choice" == "y" ]; then
    apt install -y unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
    echo "Automatic security updates enabled."
else
    echo "Skipping automatic security updates."
fi

# Step 2: Secure User Accounts and Passwords
read -p "Do you want to enforce strong password policies? (y/n): " password_policy_choice
if [ "$password_policy_choice" == "y" ]; then
    apt install -y libpam-pwquality
    sed -i '/pam_pwquality.so/d' /etc/pam.d/common-password
    echo "password requisite pam_pwquality.so retry=3 minlen=12 difok=3" >> /etc/pam.d/common-password
    echo "Password policies enforced."
else
    echo "Skipping password policy enforcement."
fi

# Step 3: Configure the Firewall
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

# Step 4: Secure SSH Access
read -p "Do you want to secure SSH access? (y/n): " ssh_choice
if [ "$ssh_choice" == "y" ]; then
    ssh_config="/etc/ssh/sshd_config"

    read -p "Do you want to change the default SSH port from 22? (y/n): " ssh_port_choice
    if [ "$ssh_port_choice" == "y" ]; then
        read -p "Enter the new SSH port (e.g., 2222): " ssh_port
        sed -i "/^#Port 22/c\Port $ssh_port" $ssh_config
        ufw allow $ssh_port
    fi

    read -p "Do you want to disable root login over SSH? (y/n): " root_login_choice
    if [ "$root_login_choice" == "y" ]; then
        sed -i '/^#PermitRootLogin/c\PermitRootLogin no' $ssh_config
    fi

    read -p "Do you want to allow only specific users to SSH? (y/n): " ssh_users_choice
    if [ "$ssh_users_choice" == "y" ]; then
        read -p "Enter the usernames allowed to SSH, separated by space: " ssh_users
        sed -i '/^#AllowUsers/d' $ssh_config
        echo "AllowUsers $ssh_users" >> $ssh_config
    fi

    read -p "Do you want to set up SSH key authentication and disable password authentication? (y/n): " ssh_key_choice
    if [ "$ssh_key_choice" == "y" ]; then
        sed -i '/^#PasswordAuthentication/c\PasswordAuthentication no' $ssh_config
        echo "Ensure your SSH public key is added to the ~/.ssh/authorized_keys file of the user."
    fi

    systemctl restart ssh
    echo "SSH configuration updated."
else
    echo "Skipping SSH security configuration."
fi

# Step 5: Install and Configure Fail2Ban
read -p "Do you want to install and configure Fail2Ban? (y/n): " fail2ban_choice
if [ "$fail2ban_choice" == "y" ]; then
    apt install -y fail2ban
    if [ ! -f /etc/fail2ban/jail.local ]; then
        cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    fi
    echo "Fail2Ban installed with default configuration."
    systemctl restart fail2ban
else
    echo "Skipping Fail2Ban installation."
fi

# Step 6: Remove Unnecessary Services and Applications
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

# Step 7: Secure Shared Memory
read -p "Do you want to secure shared memory by modifying /etc/fstab? (y/n): " shared_memory_choice
if [ "$shared_memory_choice" == "y" ]; then
    if ! grep -q 'tmpfs /run/shm' /etc/fstab; then
        echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab
        mount -o remount /run/shm
        echo "Shared memory secured."
    else
        echo "Shared memory already secured."
    fi
else
    echo "Skipping shared memory security."
fi

# Step 8: Install Antivirus Software
read -p "Do you want to install ClamAV antivirus software? (y/n): " clamav_choice
if [ "$clamav_choice" == "y" ]; then
    apt install -y clamav clamav-daemon
    freshclam
    echo "ClamAV installed and updated."
else
    echo "Skipping ClamAV installation."
fi

# Step 9: Check for Rootkits
read -p "Do you want to install and run rkhunter to check for rootkits? (y/n): " rkhunter_choice
if [ "$rkhunter_choice" == "y" ]; then
    apt install -y rkhunter
    rkhunter --update
    rkhunter --checkall
    echo "Rootkit check completed."
else
    echo "Skipping rootkit check."
fi

# Step 10: Enable AppArmor
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

# Step 11: Implement Two-Factor Authentication (2FA)
read -p "Do you want to set up Two-Factor Authentication for SSH? (y/n): " 2fa_choice
if [ "$2fa_choice" == "y" ]; then
    apt install -y libpam-google-authenticator
    read -p "Enter the username to configure 2FA for: " 2fa_user
    su - "$2fa_user" -c "google-authenticator"
    echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd
    sed -i '/^#ChallengeResponseAuthentication/c\ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
    systemctl restart ssh
    echo "2FA configured for SSH."
else
    echo "Skipping 2FA setup."
fi

# Step 12: Regularly Monitor System Logs
read -p "Do you want to install Logwatch for log monitoring? (y/n): " logwatch_choice
if [ "$logwatch_choice" == "y" ]; then
    apt install -y logwatch
    echo "Logwatch installed. Configure /usr/share/logwatch/default.conf/logwatch.conf as needed."
else
    echo "Skipping Logwatch installation."
fi

# Step 13: Secure Network Settings
read -p "Do you want to disable IPv6? (y/n): " ipv6_choice
if [ "$ipv6_choice" == "y" ]; then
    sysctl_conf="/etc/sysctl.conf"
    sed -i '/disable_ipv6/d' $sysctl_conf
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> $sysctl_conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> $sysctl_conf
    sysctl -p
    echo "IPv6 disabled."
else
    echo "Skipping IPv6 disablement."
fi

read -p "Do you want to configure sysctl for network protection? (y/n): " sysctl_choice
if [ "$sysctl_choice" == "y" ]; then
    sysctl_conf="/etc/sysctl.conf"
    echo "
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_timestamps = 0
" >> $sysctl_conf
    sysctl -p
    echo "Network settings secured."
else
    echo "Skipping sysctl network configuration."
fi

# Step 14: Limit User Privileges
read -p "Do you want to review user accounts and limit privileges? (y/n): " user_privileges_choice
if [ "$user_privileges_choice" == "y" ]; then
    cut -d: -f1 /etc/passwd
    read -p "Enter the usernames you want to remove, separated by space: " users_remove
    for user in $users_remove; do
        deluser "$user"
        echo "User $user removed."
    done
    echo "User privileges updated."
else
    echo "Skipping user privileges configuration."
fi

# Step 15: Configure AppArmor Profiles for Applications
read -p "Do you want to enforce AppArmor profiles for applications? (y/n): " apparmor_profiles_choice
if [ "$apparmor_profiles_choice" == "y" ]; then
    for profile in /etc/apparmor.d/*; do
        aa-enforce "$profile"
    done
    echo "AppArmor profiles enforced for applications."
else
    echo "Skipping AppArmor profiles enforcement."
fi

# Step 16: Encrypt Sensitive Data
read -p "Do you want to encrypt your home directory? (y/n): " encrypt_home_choice
if [ "$encrypt_home_choice" == "y" ]; then
    apt install -y ecryptfs-utils
    read -p "Enter the username whose home directory you want to encrypt: " encrypt_user
    ecryptfs-migrate-home -u "$encrypt_user"
    echo "Home directory encryption initiated for $encrypt_user. Please log out and log back in."
else
    echo "Skipping home directory encryption."
fi

# Step 17: Regular Backups
read -p "Do you want to set up a regular backup using rsync? (y/n): " backup_choice
if [ "$backup_choice" == "y" ]; then
    read -p "Enter the source directory to back up: " backup_source
    read -p "Enter the destination directory for the backup: " backup_dest
    rsync -av --delete "$backup_source" "$backup_dest"
    echo "Backup completed from $backup_source to $backup_dest."
else
    echo "Skipping backup setup."
fi

# Step 18: Install Intrusion Detection Systems (IDS)
read -p "Do you want to install AIDE for intrusion detection? (y/n): " aide_choice
if [ "$aide_choice" == "y" ]; then
    apt install -y aide
    aideinit
    mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    echo "AIDE installed and initialized."
else
    echo "Skipping AIDE installation."
fi

# Step 19: Secure Boot Loader
read -p "Do you want to set a GRUB password to secure the boot loader? (y/n): " grub_choice
if [ "$grub_choice" == "y" ]; then
    read -p "Enter the GRUB username: " grub_user
    read -s -p "Enter the GRUB password: " grub_pass
    echo
    hashed_pass=$(echo -e "$grub_pass\n$grub_pass" | grub-mkpasswd-pbkdf2 | grep "grub.pbkdf2" | awk '{print $7}')
    grub_cfg="/etc/grub.d/40_custom"
    echo "set superusers=\"$grub_user\"" >> $grub_cfg
    echo "password_pbkdf2 $grub_user $hashed_pass" >> $grub_cfg
    update-grub
    echo "GRUB password set."
else
    echo "Skipping GRUB password setup."
fi

# Step 20: Stay Informed and Vigilant
echo "It is recommended to subscribe to Ubuntu Security Notices at https://ubuntu.com/security/notices."
echo "Regularly review security best practices and keep your system updated."

echo "Ubuntu security configuration script completed."
