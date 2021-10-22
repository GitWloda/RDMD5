#!/bin/bash

#0.3b

if [[ $(eval "whoami") == "root" ]]; then
rm /usr/bin/ASF.sh
else 
	echo "please use sudo"
fi
