# Ubuntu Security Configuration Script

![Ubuntu Security](https://img.shields.io/badge/Ubuntu-Security-orange.svg)
![Shell Script](https://img.shields.io/badge/Shell-Script-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Adding New Modules](#adding-new-modules)
- [Important Notes](#important-notes)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Introduction

The **Ubuntu Security Configuration Script** is a comprehensive, modular, and interactive shell script designed to enhance the security of your Ubuntu machine. The script is organized into modules categorized by their utility, making it easy to add new features or customize existing ones.

## Features

- **Modular Design**: Security steps are broken into individual modules.
- **Easy Extensibility**: Add new modules simply by adding scripts to the `modules/` directory.
- **Organized Structure**: Modules are categorized into directories like network-security, file-security, backup, anti-virus, etc.
- **Interactive Prompts**: The script guides you through each security configuration with prompts.
- **Comprehensive Security Enhancements**: Includes system updates, firewall configuration, SSH hardening, antivirus installation, intrusion detection, and more.

## Prerequisites

- Ubuntu operating system.
- Administrative privileges (you must run the script as root).

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/kodysmith/ubuntu_secure_script.git
   cd ubuntu_secure_script
   ```

2. **Make the Main Script Executable**

   ```bash
   chmod +x main.sh
   ```

## Usage

Run the main script with root privileges:

```bash
sudo ./main.sh
```

Follow the interactive prompts to configure each security feature according to your preferences.

## Directory Structure

```
ubuntu_secure_script/
├── README.md
├── LICENSE
├── main.sh
├── modules/
    ├── network-security/
    │   ├── configure_firewall.sh
    │   ├── secure_ssh.sh
    │   ├── secure_network_settings.sh
    │   └── install_fail2ban.sh
    ├── file-security/
    │   ├── secure_shared_memory.sh
    │   ├── encrypt_home_directory.sh
    │   ├── configure_apparmor_profiles.sh
    │   └── enable_apparmor.sh
    ├── backup/
    │   └── setup_regular_backups.sh
    ├── anti-virus/
    │   ├── install_antivirus.sh
    │   └── check_rootkits.sh
    ├── user-management/
    │   ├── enforce_password_policies.sh
    │   ├── limit_user_privileges.sh
    │   └── setup_2fa.sh
    ├── system-updates/
    │   ├── update_system.sh
    │   └── enable_auto_updates.sh
    ├── intrusion-detection/
    │   └── install_aide.sh
    ├── logging/
    │   └── install_logwatch.sh
    ├── boot-security/
    │   └── secure_boot_loader.sh
    └── miscellaneous/
        ├── remove_unnecessary_services.sh
        └── display_conclusion.sh
```

## Adding New Modules

1. **Create a New Module Script**

   - Navigate to the appropriate category directory in `modules/`.
   - Create a new `.sh` script file with your module's functionality.

2. **Structure of a Module Script**

   - Start with `#!/bin/bash`.
   - Define a function that contains the module's logic.
   - Optionally, include a check to call the function if the script is run directly.

   **Example:**

   ```bash
   #!/bin/bash
   # Description of what the module does

   my_new_module() {
       # Module logic here
   }

   if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
       my_new_module
   fi
   ```

3. **Update `main.sh`**

   - Add a call to `execute_module` with the path to your new module script.

   ```bash
   execute_module "$MODULES_DIR/category-directory/your_module_script.sh"
   ```

## Important Notes

- **Backup Configuration Files**: Before running the script, it's recommended to back up important configuration files, as the script modifies system settings.

- **Understand Each Step**: The script is interactive. Make sure you understand the implications of each choice.

- **Test in a Safe Environment**: If possible, test the script in a virtual machine or development environment before running it on a production system.

- **Reboot May Be Required**: Some changes may require a system reboot to take effect, especially those related to kernel parameters or GRUB configuration.

- **SSH Configuration**: When modifying SSH settings, keep an existing session open to prevent being locked out in case of misconfiguration.

## Contributing

Contributions are welcome! If you have suggestions for improvements or additional features, please:

1. Fork the repository.

2. Create a new branch:

   ```bash
   git checkout -b feature/YourFeature
   ```

3. Commit your changes:

   ```bash
   git commit -am 'Add your feature'
   ```

4. Push to the branch:

   ```bash
   git push origin feature/YourFeature
   ```

5. Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by best practices for securing Ubuntu systems.
- Thanks to the open-source community for providing tools like Fail2Ban, ClamAV, and AppArmor.
- Special thanks to all contributors who have helped improve this script.

---

**Disclaimer**: Use this script at your own risk. The author is not responsible for any damage caused by running this script. Always ensure you have backups and understand the changes being made to your system.

---

## **Final Thoughts**

By modularizing the script into separate files and organizing them into categorized folders, you achieve a cleaner, more maintainable codebase. This structure makes it easier for others to contribute and for you to manage the project over time.

---

**Do you need assistance with any specific module, or have further questions about implementing this structure?**