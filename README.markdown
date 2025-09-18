# Octane Update Node List

This repository contains the `rc.updatenodelist` script for OCTANE NETWORK GMRS nodes to update the node list from `register.octanenetwork.net`,

You will need to be in the `bash shell` normally option 9 from the node menu,

## Installation

1. **Download the Automation Script**:
   ```bash
   sudo wget -O /tmp/update_rc.sh https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/update_rc.sh
   ```

2. **Make it Executable**:
   ```bash
   sudo chmod +x /tmp/update_rc.sh
   ```

3. **Run the Script**:
   ```bash
   sudo /tmp/update_rc.sh
   ```
   This downloads `rc.updatenodelist`, backs up the existing file, and installs the new version.

4. **Reboot your node**:
   ```bash
   sudo reboot
   ```

5. **Verify the Update**:
   ```bash
   cat /tmp/rpt_extnodes
   ```

## Notes
- Ensure `wget` is installed (`yum install wget` or `apt-get install wget`).
- The script assumes `rc.updatenodelist` is in `/usr/local/etc/`. Adjust `DEST_PATH` in `update_rc.sh` if needed.
- Check `/var/log/update_rc.log` for errors.
