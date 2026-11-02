
#!/bin/bash

# Incremental Backup Script

SOURCE="/home/raavi/company_data"
DEST="/backup/incremental"
SNAPSHOT="$DEST/snapshot.snar"
LOG="/backup/logs/incremental.log"
DATE=$(date +%Y%m%d-%H%M%S)
ARCHIVE="$DEST/incremental-$DATE.tar.gz"

echo "Starting incremental backup..."

if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source folder does not exist: $SOURCE"
    exit 1
fi

if [ -z "$(ls -A "$SOURCE")" ]; then
    echo "ERROR: Source folder is empty."
    exit 1
fi

if tar --create --gzip --file="$ARCHIVE" \
    --listed-incremental="$SNAPSHOT" \
    --directory="$SOURCE" .; then

    if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
        echo "SUCCESS: Incremental backup created: $ARCHIVE"
        echo "Incremental backup completed on $DATE: $ARCHIVE" >> "$LOG"
        exit 0
    else
        echo "ERROR: Incremental archive verification failed."
        rm -f "$ARCHIVE"
        exit 1
    fi
else
    echo "ERROR: Incremental backup failed."
    rm -f "$ARCHIVE"
    exit 1
fi
