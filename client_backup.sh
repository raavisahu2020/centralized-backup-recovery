
#!/bin/bash

# Client-to-Server Backup Transfer

SOURCE="/home/raavi/company_data"
SERVER="backupuser@localhost"
DEST="/backup/incoming"

echo "Starting client backup transfer..."

if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Client source folder not found."
    exit 1
fi

if scp -r "$SOURCE" "$SERVER:$DEST/"; then
    echo "SUCCESS: Client data transferred to backup server."
else
    echo "ERROR: Client-to-server transfer failed."
    exit 1
fi
