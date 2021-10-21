#!/bin/bash

#1.0

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
			mkdir ~/.ASFinstal
			cd ~/.ASFinstal
			git clone https://github.com/GitWloda/AutoSortFile.git
			cd AutoSortFile
			chmod 777 remASF.sh
			echo "aggiornamento eseguito"	
			./remASF.sh &
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
	;;
	* )
		echo "opzione non valida"
		echo "usa \"-h\" o \"--help\" per vedere tutte le opzioni"
		exit
	;;
esac
