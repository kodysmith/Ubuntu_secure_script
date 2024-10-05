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
    function_name="$2"
    if [ -f "$module_script" ]; then
        source "$module_script"
        # Call the function
        $function_name
    else
        echo "Module $module_script not found."
    fi
}

# Execution flow
execute_module "$MODULES_DIR/system-updates/update_system.sh" "update_system"
execute_module "$MODULES_DIR/system-updates/enable_auto_updates.sh" "enable_auto_updates"
execute_module "$MODULES_DIR/user-management/enforce_password_policies.sh" "enforce_password_policies"
execute_module "$MODULES_DIR/network-security/configure_firewall.sh" "configure_firewall"
execute_module "$MODULES_DIR/network-security/secure_ssh.sh" "secure_ssh"
execute_module "$MODULES_DIR/network-security/install_fail2ban.sh" "install_fail2ban"
execute_module "$MODULES_DIR/miscellaneous/remove_unnecessary_services.sh" "remove_unnecessary_services"
execute_module "$MODULES_DIR/file-security/secure_shared_memory.sh" "secure_shared_memory"
execute_module "$MODULES_DIR/anti-virus/install_antivirus.sh" "install_antivirus"
execute_module "$MODULES_DIR/anti-virus/check_rootkits.sh" "check_rootkits"
execute_module "$MODULES_DIR/file-security/enable_apparmor.sh" "enable_apparmor"
execute_module "$MODULES_DIR/user-management/setup_2fa.sh" "setup_2fa"
execute_module "$MODULES_DIR/logging/install_logwatch.sh" "install_logwatch"
execute_module "$MODULES_DIR/network-security/secure_network_settings.sh" "secure_network_settings"
execute_module "$MODULES_DIR/user-management/limit_user_privileges.sh" "limit_user_privileges"
execute_module "$MODULES_DIR/file-security/configure_apparmor_profiles.sh" "configure_apparmor_profiles"
execute_module "$MODULES_DIR/file-security/encrypt_home_directory.sh" "encrypt_home_directory"
execute_module "$MODULES_DIR/backup/setup_regular_backups.sh" "setup_regular_backups"
execute_module "$MODULES_DIR/intrusion-detection/install_aide.sh" "install_aide"
execute_module "$MODULES_DIR/boot-security/secure_boot_loader.sh" "secure_boot_loader"
execute_module "$MODULES_DIR/miscellaneous/display_conclusion.sh" "display_conclusion"
