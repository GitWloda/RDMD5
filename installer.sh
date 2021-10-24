#!/bin/bash

#1.0a

if [[ $(eval "whoami") == "root" ]]; then
rm /usr/bin/ASF.sh
chmod 777 ASF.sh
cp ./ASF.sh /usr/bin/
rm -rf ~/.ASFinstall &
else 
	echo "please use sudo"
fi
