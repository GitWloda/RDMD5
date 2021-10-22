#!/bin/bash

#0.3b

if [[ $(eval "whoami") == "root" ]]; then
rm /usr/bin/ASF.sh
chmod 777 ASF.sh
mv ./ASF.sh /usr/bin/
rm -rf ~/.ASFinstall &
else 
	echo "please use sudo"
fi
