#!/bin/bash

#1.0
if [[ $(eval "whoami") == "root" ]]; then
mesi[1]="january"
mesi[2]="february"
mesi[3]="march"
mesi[4]="april"
mesi[5]="may"
mesi[6]="june"
mesi[7]="july"
mesi[8]="august"
mesi[9]="september"
mesi[10]="october"
mesi[11]="november"
mesi[12]="december"

case $1 in
	"-U" | "--update" )
		ping -c 1 google.com && internetPing="true"
		if [[ "$internetPing" == "true" ]]; then
			git --version ||  notInstall="true"
			if [[ "$notInstall" == "true" ]]; then
				declare -A osInfo;
				osInfo[/etc/arch-release]=pacman
				osInfo[/etc/debian_version]=apt-get

				case "${!osInfo[@]}" in
					"pacman" )
						sudo pacman -S git
					;;
					"apt-get" )
						sudo apt-get install git
					;;
					*)
						echo "please install git"
						exit
					;;
				esac
			fi
			mkdir ~/.ASFinstall
			cd ~/.ASFinstall
			git clone https://github.com/GitWloda/AutoSortFile.git
			cd AutoSortFile
			chmod 777 installer.sh
			echo "aggiornamento eseguito"	
			./installer.sh &
			exit
		else
			clear
			echo "NO NETWORK CONNECTION... PLEASY TRY AGAIN"
			exit
		fi
	;;
	"-S" | "--sort" )
	;;
	"-H" | "--help" )
		echo "-S or --sort for sort files"
		echo "-U or --update for update"
		echo "-R or --remove for uninstall"
		echo "-H or --help for the help list"
		exit
	;;
	* )
		echo "opzione non valida"
		echo "usa \"-h\" o \"--help\" per vedere tutte le opzioni"
		exit
	;;
esac
else 
	echo "please use sudo"
fi
