# octane-updatenodelist

from the bash shell (normally option 9 on menu) 

type or copy/paste this command and run it. 

wget -O /tmp/update_rc.sh https://raw.githubusercontent.com/joshnbrown23/octane-updatenodelist/main/update_rc.sh

Now go to the tmp folder

#cd /tmp

make the update_rc.sh Excutable

chmod +x update_rc.sh

Now we need to run this command to update the required file. 

./update_rc.sh


Let this run, its quick an then reboot your node. once done your node will now pull the required node list to be able to connect to the network. 
