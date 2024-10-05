#!/bin/bash
# Secure Shared Memory

secure_shared_memory() {

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

}

# If the script is run directly, execute the function
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    secure_shared_memory
fi
