
#!/bin/bash

# Full Backup Script

SOURCE="/home/raavi/company_data"
DEST="/backup/full"
LOG="/backup/logs/backup.log"
DATE=$(date +%Y%m%d-%H%M%S)
ARCHIVE="$DEST/backup_$DATE.tar.gz"

echo "Starting full backup..."

# Check whether the source folder exists
if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source folder does not exist: $SOURCE"
    exit 1
fi

# Check whether the source contains files
if [ -z "$(ls -A "$SOURCE")" ]; then
    echo "ERROR: Source folder is empty."
    exit 1
fi

# Create the backup archive and check the result
if tar -czf "$ARCHIVE" -C "$SOURCE" .; then
    if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
        echo "SUCCESS: Full backup created: $ARCHIVE"
        echo "Backup completed on $DATE: $ARCHIVE" >> "$LOG"
        exit 0
    else
        echo "ERROR: Backup archive verification failed."
        rm -f "$ARCHIVE"
        exit 1
    fi
else
    echo "ERROR: Failed to create full backup."
    rm -f "$ARCHIVE"
    exit 1
fi
