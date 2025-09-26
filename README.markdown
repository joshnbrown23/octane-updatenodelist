# Octane Update Node List

This repository contains the new `rc.updatenodelist` script for OCTANE NETWORK GMRS nodes.

** It also adds the required info to your `iax.conf` file to be able to successfully register to the new Octane Registration Server.

**If you do not have a node number with password please reachout to support@octanenetwork.net to get registered on the new server.**

Without this information you will NOT be able to connect to any of the existing hubs.

**You will need to be in the `bash shell` normally option 9 from the node menu**

## Run at once script - click the copy button and then paste this into the bash shell - you should be prompted with a Blue screen asking for your node number.

   ``` bash
   sudo wget -O /tmp/update_rc.sh https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/fullupdatenode.sh
   sudo chmod +x /tmp/update_rc.sh
   sudo /tmp/update_rc.sh

   ```

## Installation

1. **Download the Automation Script**:
   ```bash
   sudo wget -O /tmp/update_rc.sh https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/fullupdatenode.sh
   ```

2. **Make it Executable**:
   ```bash
   sudo chmod +x /tmp/update_rc.sh
   ```

3. **Run the Script**:
   ```bash
   sudo /tmp/update_rc.sh
   ```
   This downloads `rc.updatenodelist`, backs up the existing file, and installs the new version. Then Creates the required register line in your iax.conf file. It does backup your old file just in case.
  ```

## Notes
- Ensure `wget` is installed (`yum install wget` or `apt-get install wget`).
- The script assumes `rc.updatenodelist` is in `/usr/local/etc/`. Adjust `DEST_PATH` in `update_rc.sh` if needed.
- Check `/var/log/update_rc.log` for errors.
