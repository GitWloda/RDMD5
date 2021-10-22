#!/bin/bash

#0.3b

if [[ $(eval "whoami") == "root" ]]; then
rm /usr/bin/ASF.sh
rm -rf ~/.ASFinstall &
else 
	echo "please use sudo"
fi
