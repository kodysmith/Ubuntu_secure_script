#!/bin/bash
# Setup Regular Backups

setup_regular_backups() {

    read -p "Do you want to set up a regular backup using rsync? (y/n): " backup_choice
    if [ "$backup_choice" == "y" ]; then
        read -p "Enter the source directory to back up: " backup_source
        read -p "Enter the destination directory for the backup: " backup_dest
        rsync -av --delete "$backup_source" "$backup_dest"
        echo "Backup completed from $backup_source to $backup_dest."
    else
        echo "Skipping backup setup."
    fi

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    setup_regular_backups
fi
