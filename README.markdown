# Octane Update Node List

This repository contains the `rc.updatenodelist` script for HamVoIP nodes to update the node list from `register.octanenetwork.net`.

## Installation

1. **Download the Automation Script**:
   ```bash
   wget -O /tmp/update_rc.sh https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/update_rc.sh
   ```

2. **Make it Executable**:
   ```bash
   chmod +x /tmp/update_rc.sh
   ```

3. **Run the Script**:
   ```bash
   /tmp/update_rc.sh
   ```
   This downloads `rc.updatenodelist`, backs up the existing file, and installs the new version.

4. **Verify the Update**:
   ```bash
   cat /usr/local/etc/rc.updatenodelist
   cat /var/log/update_rc.log
   ```

5. **Automate Updates (Optional)**:
   Move the script:
   ```bash
   mv /tmp/update_rc.sh /usr/local/bin/
   ```
   Schedule a daily cron job:
   ```bash
   crontab -e
   ```
   Add:
   ```bash
   0 2 * * * /usr/local/bin/update_rc.sh >> /var/log/update_rc.log 2>&1
   ```

## Notes
- Ensure `wget` is installed (`yum install wget` or `apt-get install wget`).
- The script assumes `rc.updatenodelist` is in `/usr/local/etc/`. Adjust `DEST_PATH` in `update_rc.sh` if needed.
- Check `/var/log/update_rc.log` for errors.