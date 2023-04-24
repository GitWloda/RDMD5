mkdir -p /home/$USER/.cache/rdmd5
touch /home/$USER/.cache/rdmd5/datacache.txt
touch /home/$USER/.cache/rdmd5/datahash.txt
touch /home/$USER/.cache/rdmd5/data.txt
touch /home/$USER/.cache/rdmd5/equaldata.txt
> /home/$USER/.cache/rdmd5/datacache.txt #reset the file
> /home/$USER/.cache/rdmd5/datahash.txt #reset the file
> /home/$USER/.cache/rdmd5/data.txt #reset the file
> /home/$USER/.cache/rdmd5/equaldata.txt #reset the file
echo "insert the path"
read path


echo -e "1) md5 \033[0;32m(raccomanded)\033[0m"
echo "2) sha1"
echo "3) sha224"
echo "4) sha256"
echo "5) sha384"
echo "6) sha512"
echo -e "7) other type of hash \033[0;31m(NOT raccomanded, you can have some problems)\033[0m"
echo "0) exit"
read option
#option=1
case $option in
1)
	sum="md5sum"
	;;
2)
	sum="sha1sum"
	;;
3)
	sum="sha224sum"
	;;
4)
	sum="sha256sum"
	;;
5)
	sum="sha384sum"
	;;
6)
	sum="sha512sum"
	;;
7)
	echo "write the name of hash (ex: md5sum)"
	read sum
	;;
0)
	exit
	;;
*)
	exit
	;;
esac

#path=/home/phi/rdmd5/testDir/
echo -n "searching all file..."
find $path -type f > /home/$USER/.cache/rdmd5/datacache.txt

nrFile=$(cat /home/$USER/.cache/rdmd5/datacache.txt | wc -l)
echo -e "  \033[0;32m [COMPLETED]\xE2\x9C\x94 \033[0m"
echo "$nrFile file found"
nrFileSearch=$nrFile
while [ "$nrFileSearch" -gt "0" ]
do
  hash=$($sum "$(cat /home/$USER/.cache/rdmd5/datacache.txt | tail -$nrFileSearch | head -1)")
  echo $hash >> /home/$USER/.cache/rdmd5/datahash.txt
  
  let "nrFileSearch=$nrFileSearch - 1"
  let "restFile=$nrFile-$nrFileSearch"
  echo -ne "hashing all file... $restFile/$nrFile\r"
done
echo -e "hashing all file... $restFile/$nrFile\033[0;32m [COMPLETED]\xE2\x9C\x94 \033[0m"
echo -n "sorting all file..."
sort /home/$USER/.cache/rdmd5/datahash.txt >> /home/$USER/.cache/rdmd5/data.txt
#cat /home/$USER/.cache/rdmd5/data.txt
echo -e "  \033[0;32m [COMPLETED]\xE2\x9C\x94 \033[0m"
nrFileSearch=$nrFile
while [ "$nrFileSearch" -gt "1" ]
do
  Fline=$(cat /home/$USER/.cache/rdmd5/data.txt | tail -$nrFileSearch | head -1 | awk '{print $1}') 
  let  "nrFileMenoUno=$nrFileSearch -1"
  Sline=$(cat /home/$USER/.cache/rdmd5/data.txt | tail -$nrFileMenoUno | head -1 | awk '{print $1}') 
  #echo $Fline
  #echo $Sline
  if [[ "$Fline" == "$Sline" ]]
  then
  #  echo "equal"
    cat /home/$USER/.cache/rdmd5/data.txt | tail -$nrFileSearch | head -1 | cut -f 2- -d ' ' >> /home/$USER/.cache/rdmd5/equaldata.txt
    cat /home/$USER/.cache/rdmd5/data.txt | tail -$nrFileMenoUno | head -1 | cut -f 2- -d ' ' >> /home/$USER/.cache/rdmd5/equaldata.txt
    checkEq=0
  else
	  if [[ "$checkEq" == "0" ]]
	  then
		echo "endTape-startingNewTape" >> /home/$USER/.cache/rdmd5/equaldata.txt 
		checkEq=1
	  fi
  #  echo "not equal"
  fi
  let "nrFileSearch=$nrFileSearch -1"
  let "restFile=$nrFile-$nrFileSearch"
	echo -ne "checking all file... $restFile/$nrFile\r"
done
echo -e "checking all file... $restFile/$nrFile\033[0;32m [COMPLETED]\xE2\x9C\x94 \033[0m\r"
echo "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | grep -i endTape | wc -l) group finded"
echo "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | grep -v endTape | wc -l) file finded"
echo "1) automatic"
echo "2) manual"
echo "3) show"
echo "4) add new path"
echo "5) change path"
echo "0) exit"
read option
#option=1
case $option in
  1)
	rowFile=$(cat /home/$USER/.cache/rdmd5/equaldata.txt | wc -l)
	totalBite=0
	while [ "$rowFile" -gt "1" ]
	do
		let "rowFileMinusOne=$rowFile-1"
		if [[ "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFileMinusOne | head -1)" == "endTape-startingNewTape" ]]
		then
			let "rowFile=$rowFile-1"
		else
			biteFileToCheck=$(stat -c %s "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFile | head -1)" | awk '{print $1}')
			biteFileWithCheck=$(stat -c %s "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFileMinusOne | head -1)" | awk '{print $1}')
			if [[ "$biteFileToCheck" -eq "$biteFileWithCheck" ]]
			then
				deepFileToCheck=$(tr -dc '/' <<< "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFile | head -1)" | wc -c)
				deepFilewithCheck=$(tr -dc '/' <<< "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFileMinusOne | head -1)" | wc -c)
				if [[ "$deepFileToCheck" -gt "$deepFileWithCheck" ]]
				then
					rm -rf "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFile | head -1)"
					let "rowFile=$rowFile-1"		
					let "totalBite=$totalBite + $biteFileToCheck"
				else

					rm -rf "$(cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFileMinusOne | head -1)"
					let "rowFile=$rowFile-1"
					let "totalBite=$totalBite + $biteFileWithCheck"
				fi
			else
				echo "space different"
				cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFile | head -1
cat /home/$USER/.cache/rdmd5/equaldata.txt | tail -$rowFileMinusOne | head -1
			fi
		fi
		let "rowFile = $rowFile-1"
	done
	echo "$totalBite"
    ;;
  2)
    echo "ko"
    ;;
  3)
    echo "ko"
    ;;
  4)
    echo "ko"
    ;;
  5)
    echo "ko"
    ;;
  0)
	exit
    ;;
  *)
    exit
    ;;
esac
