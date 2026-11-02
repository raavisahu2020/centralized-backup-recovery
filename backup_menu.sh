
#!/bin/bash

# Centralized Backup and Recovery System
# Main menu-driven interface

SOURCE="/home/raavi/company_data"
BACKUP="/backup"
FULL_SCRIPT="/home/raavi/backup.sh"
INCREMENTAL_SCRIPT="/home/raavi/incremental_backup.sh"

pause_screen() {
    echo
    read -r -p "Press Enter to return to the menu..."
}

full_backup() {
    echo
    echo "Starting full backup..."

    if [ ! -d "$SOURCE" ]; then
        echo "ERROR: Source folder does not exist: $SOURCE"
        return
    fi

    if sudo /bin/bash "$FULL_SCRIPT"; then
        echo "SUCCESS: Full backup completed."
        sudo ls -lh "$BACKUP/full"
    else
        echo "ERROR: Full backup failed."
    fi
}

incremental_backup() {
    echo
    echo "Starting incremental backup..."

    if [ ! -d "$SOURCE" ]; then
        echo "ERROR: Source folder does not exist: $SOURCE"
        return
    fi

    if sudo /bin/bash "$INCREMENTAL_SCRIPT"; then
        echo "SUCCESS: Incremental backup completed."
        sudo ls -lht "$BACKUP/incremental"
    else
        echo "ERROR: Incremental backup failed."
    fi
}

restore_backup() {
    echo
    echo "Available full backups:"
    sudo ls -1 "$BACKUP/full"/*.tar.gz 2>/dev/null

    echo
    read -r -p "Enter the full backup filename: " filename

    if [[ -z "$filename" || "$filename" == */* ]]; then
        echo "ERROR: Enter a filename only."
        return
    fi

    archive="$BACKUP/full/$filename"

    if ! sudo test -f "$archive"; then
        echo "ERROR: Backup file not found."
        return
    fi

    read -r -p "Enter restore folder [/backup/recovery/restored]: " destination
    destination="${destination:-/backup/recovery/restored}"

    if [[ "$destination" != /backup/recovery/* ]]; then
        echo "ERROR: Restore location must be inside /backup/recovery."
        return
    fi

    if ! sudo mkdir -p -- "$destination"; then
        echo "ERROR: Could not create restore folder."
        return
    fi

    if sudo tar -tzf "$archive" >/dev/null 2>&1 &&
       sudo tar -xzf "$archive" -C "$destination"; then
        echo "SUCCESS: Files restored to $destination"
        sudo ls -la "$destination"
    else
        echo "ERROR: Restore failed or archive is invalid."
    fi
}

view_backups() {
    echo
    echo "========== FULL BACKUPS =========="
    sudo ls -lh "$BACKUP/full"

    echo
    echo "======= INCREMENTAL BACKUPS ======"
    sudo ls -lh "$BACKUP/incremental"

    echo
    echo "============= BACKUP LOG ========="
    if sudo test -f "$BACKUP/logs/backup.log"; then
        sudo tail -n 10 "$BACKUP/logs/backup.log"
    else
        echo "No full-backup log found."
    fi

    if sudo test -f "$BACKUP/logs/incremental.log"; then
        echo
        echo "======= INCREMENTAL LOG =========="
        sudo tail -n 10 "$BACKUP/logs/incremental.log"
    fi
}

check_storage() {
    echo
    echo "========== BACKUP STORAGE =========="
    df -h "$BACKUP"

    echo
    echo "========== STORAGE PERMISSIONS ====="
    sudo ls -ld "$BACKUP" "$BACKUP/full" \
        "$BACKUP/incremental" "$BACKUP/recovery" "$BACKUP/logs"
}

while true; do
    clear
    echo "=========================================="
    echo " CENTRALIZED BACKUP & RECOVERY SYSTEM"
    echo "=========================================="
    echo "1. Perform Full Backup"
    echo "2. Perform Incremental Backup"
    echo "3. Restore a Full Backup"
    echo "4. View Backups and Logs"
    echo "5. Check Backup Storage"
    echo "6. Exit"
    echo "=========================================="

    read -r -p "Enter your choice (1-6): " choice

    case "$choice" in
        1)
            full_backup
            pause_screen
            ;;
        2)
            incremental_backup
            pause_screen
            ;;
        3)
            restore_backup
            pause_screen
            ;;
        4)
            view_backups
            pause_screen
            ;;
        5)
            check_storage
            pause_screen
            ;;
        6)
            echo "Thank you for using the Backup & Recovery System."
            exit 0
            ;;
        *)
            echo "ERROR: Invalid choice. Please enter a number from 1 to 6."
            pause_screen
            ;;
    esac
done
