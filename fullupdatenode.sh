#!/bin/bash

# Configuration
GITHUB_URL="https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/rc.updatenodelist"
DEST_PATH="/usr/local/etc/rc.updatenodelist"  # Path for rc.updatenodelist
BACKUP_PATH="/usr/local/etc/rc.updatenodelist.bak"
TEMP_FILE="/tmp/rc.updatenodelist.new"
IAX_CONF="/etc/asterisk/iax.conf"  # Path for iax.conf
IAX_BACKUP="/etc/asterisk/iax.conf.bak"
WGET=$(which wget)
CHMOD=$(which chmod)
CP=$(which cp)
MV=$(which mv)
RM=$(which rm)
DATE=$(which date)
SED=$(which sed)
DIALOG=$(which dialog)

# Check if required commands are installed
for cmd in "$WGET" "$CHMOD" "$CP" "$MV" "$RM" "$SED"; do
    if [ -z "$cmd" ]; then
        echo "Error: Required command not found. Please install wget, chmod, cp, mv, rm, and sed."
        exit 1
    fi
done

# Log start time
echo "Starting update at $($DATE)" >> /var/log/update_rc.log

# --- Update rc.updatenodelist ---
# Backup existing rc.updatenodelist
if [ -f "$DEST_PATH" ]; then
    echo "Backing up existing $DEST_PATH to $BACKUP_PATH"
    $CP "$DEST_PATH" "$BACKUP_PATH"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup of $DEST_PATH at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
fi

# Download the new rc.updatenodelist from GitHub
echo "Downloading new script from $GITHUB_URL"
$WGET -q -O "$TEMP_FILE" "$GITHUB_URL"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download script from GitHub at $($DATE)" >> /var/log/update_rc.log
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Verify the downloaded file (check for non-empty)
if [ ! -s "$TEMP_FILE" ]; then
    echo "Error: Downloaded file is empty or invalid at $($DATE)" >> /var/log/update_rc.log
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Set permissions for rc.updatenodelist
echo "Setting permissions on new rc.updatenodelist"
$CHMOD 755 "$TEMP_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set permissions for $TEMP_FILE at $($DATE)" >> /var/log/update_rc.log
    $RM -f "$TEMP_FILE"
    exit 1
fi

# Replace the existing rc.updatenodelist
echo "Replacing $DEST_PATH with new script"
$MV -f "$TEMP_FILE" "$DEST_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to replace $DEST_PATH at $($DATE)" >> /var/log/update_rc.log
    exit 1
fi

# --- Update iax.conf ---
# Prompt user for node number and password using dialog (if available) or read
if [ -n "$DIALOG" ]; then
    # Use dialog for input
    NODE=$($DIALOG --title "Node Number" --inputbox "Enter your node number:" 8 40 2>&1 >/dev/tty)
    DIALOG_STATUS=$?
    if [ $DIALOG_STATUS -ne 0 ] || [ -z "$NODE" ]; then
        echo "Error: Node number cannot be empty or dialog cancelled at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
    PASSWORD=$($DIALOG --title "Password" --inputbox "Enter your password (visible for verification):" 8 40 2>&1 >/dev/tty)
    DIALOG_STATUS=$?
    if [ $DIALOG_STATUS -ne 0 ] || [ -z "$PASSWORD" ]; then
        echo "Error: Password cannot be empty or dialog cancelled at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
else
    # Fallback to read if dialog is not installed
    echo "Dialog utility not found, using standard input."
    echo "Please enter your node number:"
    read -r NODE
    if [ -z "$NODE" ]; then
        echo "Error: Node number cannot be empty at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
    echo "Please enter your password (input hidden):"
    read -r -s PASSWORD  # -s hides password input
    if [ -z "$PASSWORD" ]; then
        echo "Error: Password cannot be empty at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
    echo  # Newline after hidden password input
fi

# Backup existing iax.conf
if [ -f "$IAX_CONF" ]; then
    echo "Backing up existing $IAX_CONF to $IAX_BACKUP"
    $CP "$IAX_CONF" "$IAX_BACKUP"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup of $IAX_CONF at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
else
    echo "Error: $IAX_CONF not found at $($DATE)" >> /var/log/update_rc.log
    exit 1
fi

# Check if register line already exists to avoid duplicates
if grep -q "register.*=>.*@register.octanenetwork.net" "$IAX_CONF"; then
    echo "Warning: A register line for register.octanenetwork.net already exists in $IAX_CONF. Replacing it."
    $SED -i "/register.*=>.*@register.octanenetwork.net/d" "$IAX_CONF"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove existing register line from $IAX_CONF at $($DATE)" >> /var/log/update_rc.log
        exit 1
    fi
fi

# Insert the register line at line 24
echo "Adding register line to $IAX_CONF at line 24"
$SED -i "24i register => $NODE:$PASSWORD@register.octanenetwork.net" "$IAX_CONF"
if [ $? -ne 0 ]; then
    echo "Error: Failed to add register line to $IAX_CONF at $($DATE)" >> /var/log/update_rc.log
    exit 1
fi

# Set permissions for iax.conf
echo "Setting permissions on $IAX_CONF"
$CHMOD 644 "$IAX_CONF"
if [ $? -ne 0 ]; then
    echo "Error: Failed to set permissions for $IAX_CONF at $($DATE)" >> /var/log/update_rc.log
    exit 1
fi
# Set ownership to asterisk user (common for HamVoIP/Asterisk)
chown asterisk:asterisk "$IAX_CONF" 2>/dev/null || echo "Warning: Failed to set ownership of $IAX_CONF (may not be needed) at $($DATE)" >> /var/log/update_rc.log

# Restart Asterisk to apply iax.conf changes (if applicable)
if [ -x "$(which asterisk)" ]; then
    echo "Restarting Asterisk to apply changes"
    asterisk -rx "module reload iax2" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to reload IAX2 module, consider restarting Asterisk manually at $($DATE)" >> /var/log/update_rc.log
    fi
fi

echo "Update completed successfully at $($DATE)" >> /var/log/update_rc.log
echo "Update completed successfully."
exit 0
