#!/bin/bash
# Ubuntu Security Configuration Main Script

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Please run 'sudo ./main.sh'"
   exit 1
fi

echo "Welcome to the Ubuntu Security Configuration Script!"

# Define the modules directory
MODULES_DIR="./modules"

# Function to execute a module script
execute_module() {
    module_script="$1"
    if [ -f "$module_script" ]; then
        source "$module_script"
    else
        echo "Module $module_script not found."
    fi
}

# Execution flow
execute_module "$MODULES_DIR/system-updates/update_system.sh"
execute_module "$MODULES_DIR/system-updates/enable_auto_updates.sh"
execute_module "$MODULES_DIR/user-management/enforce_password_policies.sh"
execute_module "$MODULES_DIR/network-security/configure_firewall.sh"
execute_module "$MODULES_DIR/network-security/secure_ssh.sh"
execute_module "$MODULES_DIR/network-security/install_fail2ban.sh"
execute_module "$MODULES_DIR/miscellaneous/remove_unnecessary_services.sh"
execute_module "$MODULES_DIR/file-security/secure_shared_memory.sh"
execute_module "$MODULES_DIR/anti-virus/install_antivirus.sh"
execute_module "$MODULES_DIR/anti-virus/check_rootkits.sh"
execute_module "$MODULES_DIR/file-security/enable_apparmor.sh"
execute_module "$MODULES_DIR/user-management/setup_2fa.sh"
execute_module "$MODULES_DIR/logging/install_logwatch.sh"
execute_module "$MODULES_DIR/network-security/secure_network_settings.sh"
execute_module "$MODULES_DIR/user-management/limit_user_privileges.sh"
execute_module "$MODULES_DIR/file-security/configure_apparmor_profiles.sh"
execute_module "$MODULES_DIR/file-security/encrypt_home_directory.sh"
execute_module "$MODULES_DIR/backup/setup_regular_backups.sh"
execute_module "$MODULES_DIR/intrusion-detection/install_aide.sh"
execute_module "$MODULES_DIR/boot-security/secure_boot_loader.sh"
execute_module "$MODULES_DIR/miscellaneous/display_conclusion.sh"
