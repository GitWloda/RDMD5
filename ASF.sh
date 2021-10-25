#!/bin/bash

#1.0a



IFS=$'\n'

if [[ $(eval "whoami") == "root" ]]; then

prog(){
	until [[ -d $(eval "echo $dirfrom") ]]; do
		echo "Cartella da controllare"
		read dirfrom
		if [[ -d $(eval "echo $dirfrom") ]]; then
			echo "OK"
		else
			echo "DIR NON ESISTENTE"
		fi
	done
	NRFile=$(ls $(eval "echo $dirfrom") | wc -l)
	echo $dirfrom
	mysql --user=root -se "create database if not exists ASF else drop database ASF;
		create database ASF;
		create table ASFtable (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, name varchar(128), date DATE);"
	while [[ $NRFile > 0 ]]; do
		cd $(eval "echo $dirfrom")
		echo -ne "\e[96m$NRFile\033[0K\r"
		nomeFile=$(ls -1 $(eval "echo $dirfrom") | tail -$NRFile | head -n1)
		data=$(stat $(eval "echo $dirfrom")/$nomeFile | tail -3 | head -n1 | cut -d ':' -f 2 | awk {'print $1'})
		mysql --user=root -se "use ASF;
		insert into ASFtable (name, date) values ('$nomeFile','$data');"
		let NRFile=NRFile-1
	done
		mysql --user=root -se "use ASF; SELECT * from ASFtable"
}

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
		echo "starting..."
		prog
	;;
	"-R" | "--remove" )
		rm /usr/bin/ASF.sh &
		#
	;;
	"-V" | "--version" )
		echo "ver: 1.0a"
		#
	;;
	"-H" | "--help" )
		echo "-S or --sort for sort files"
		echo "-U or --update for update"
		echo "-R or --remove for uninstall"
		echo "-V or --remove for see the actual version"
		echo "-H or --help for the help list"
		exit
	;;
	* )
		echo "opzione non valida"
		echo "usa \"-H\" o \"--help\" per vedere tutte le opzioni"
		exit
	;;
esac

else 
	echo "please use sudo"
fi
