#!/bin/bash

# Configuration
GITHUB_URL="https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/refs/heads/main/rc.updatenodelist"
DEST_PATH="/usr/local/etc/rc.updatenodelist"  # Adjust path if needed
BACKUP_PATH="/usr/local/etc/rc.updatenodelist.bak"
TEMP_FILE="/tmp/rc.updatenodelist.new"
WGET=$(which wget)
CHMOD=$(which chmod)
CP=$(which cp)
MV=$(which mv)
RM=$(which rm)

# Check if wget is installed
if [ -z "$WGET" ]; then
    echo "Error: wget not found. Please install wget."
    exit 1
fi

# Backup existing file
if [ -f "$DEST_PATH" ]; then
    echo "Backing up existing $DEST_PATH to $BACKUP_PATH"
    $CP "$DEST_PATH" "$BACKUP_PATH"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup."
        exit 1
    fi
fi

# Download the new script from GitHub
echo "Downloading new script from $GITHUB_URL"
$WGET -q -O "$TEMP_FILE" "$GITHUB_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download script from GitHub."
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Verify the downloaded file (basic check for non-empty file)
if [ ! -s "$TEMP_FILE" ]; then
    echo "Error: Downloaded file is empty or invalid."
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Set permissions
echo "Setting permissions on new script"
$CHMOD 755 "$TEMP_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set permissions."
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Replace the existing file
echo "Replacing $DEST_PATH with new script"
$MV -f "$TEMP_FILE" "$DEST_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to replace $DEST_PATH."
    exit 1
fi

echo "Update completed successfully."
exit 0
```
