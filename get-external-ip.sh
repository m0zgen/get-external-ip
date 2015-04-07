#!/bin/bash

# Author Yevgeniy Goncharov aka xck, http://sys-admin.kz
# Alternative addresses http://ipecho.net/plain / curl ipinfo.io/ip
# NOTE: send mail use "mail" client

# Log files - IP and actions
LOGFILE="/var/log/get_external_ip.log"
LOGACTIONFILE="/var/log/get_external_ip_action.log"

# Get external IP
IP=$(curl sys-admin.kz/ip.php)
#curl sys-admin.kz/ip.php; echo

# Current date
DATE=`date -R`

# Email message
MESSAGE="New IP - $IP"

# Mail
SUBJECT="External IP changed"
EMAILTO="root"

# Sendmail
SMSUBJECT="External IP changed"
SMFROM="root"
# Several eail usage example
# SMTO="root user2 user3 etc"
SMTO="root"
SMAIL="subject:$SMSUBJECT\nfrom:$SMFROM\n$MESSAGE"

# Check log file exist
checkfile(){
	if [ ! -f "$LOGFILE" ]
	then
	    touch $LOGFILE
	    echo -e "LOGFILE" > $LOGFILE
	fi
	if [ ! -f "$LOGACTIONFILE" ]
	then
	    touch $LOGACTIONFILE
	    echo -e "LOGACTIONFILE" > $LOGACTIONFILE
	fi
}

checkfile

# See in to log file
for next in `cat $LOGFILE`
do
	echo $next from $LOGFILE

	if [[ "$next" == "$IP" ]]; then
		echo "Equals!"
	else
		echo "New IP - $IP"
		echo $IP > $LOGFILE
		echo "$IP : changed : $DATE" >> $LOGACTIONFILE
		# send from mail
		# /bin/mail -s "$SUBJECT" "$EMAILTO" < $MESSAGE
		echo -e $SMAIL | /usr/sbin/sendmail "$SMTO"
		
	fi

done

exit 0

