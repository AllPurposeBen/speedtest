#!/bin/bash

#Global variables
speedtest_cli="/usr/local/bin/speedtest_cli --simple"
speedLog=/Library/Logs/SpeedTest.log

doCheck () {
timeStamp=$(date +"%Y-%m-%d %H:%M:%S")
#Lets make sure we've got the binary, else log and bail
if [ ! -e $speedtest ]; then
	echo "$timeStamp - speedtest_cli binary missing!" >> $speedLog
	exit 2
fi


#make sure we can get out
ping -c 3 8.8.8.8 >/dev/null
if [ $? -eq 0 ]; then
	runCheck=$(speedtest_cli --simple | tr '\n' ',' | sed 's/,$//')
	pubIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '"')
	#Write data to log file
	echo "$timeStamp [IP: $pubIP] - $runCheck" >> $speedLog
else
	#couldn’t get out
	echo "$timeStamp [WARN] Could not ping outside world!" >> $speedLog
fi
}

while true; do
	doCheck
	sleep 300
done

exit 0
