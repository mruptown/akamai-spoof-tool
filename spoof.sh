#!/bin/sh

DELIMITER="###SPOOF ENTRIES BELOW###"

HOST_FILE=/etc/hosts

SPOOF_ENTRIES="\n$DELIMITER\n"

#backup existing host file
cp /etc/hosts /etc/hosts.backup
	
#remove existing spoof entries
echo "`sed -n '/'"$DELIMITER"'/q;p' <"$HOST_FILE"`" > "$HOST_FILE"

if [ "$1" != "-d" ]; then
	#take sites.txt in as input and loop through each line
	while read p; do
		if [ -n "$(echo $p)" ]; then
			#get prod Akamai nslookup
			LINE_WITH_DNS_ENTRY="$(nslookup $p | grep 'edgekey.net.$')"

			#parse out prod Akamai hostname
			PROD_DNS_ENTRY_WITH_PERIOD=${LINE_WITH_DNS_ENTRY/*canonical name = /}
			PROD_DNS_ENTRY=${PROD_DNS_ENTRY_WITH_PERIOD/edgekey.net./edgekey.net}

			#create staging Akamai hostname
			STAGING_DNS_ENTRY=${PROD_DNS_ENTRY/key.net/key-staging.net}

			if [ -n "$(echo $STAGING_DNS_ENTRY)" ]; then
				#get staging Akamai nslookup
				LINE_WITH_STAGING_IP="$(nslookup $STAGING_DNS_ENTRY | tail -2 | head -1)"

				#parse out staging Akamai hostname
				STAGING_IP=${LINE_WITH_STAGING_IP/Address: /}
				SPOOF_ENTRIES+="$STAGING_IP $p\n"
			fi
		fi
	done <sites.txt

	echo "$SPOOF_ENTRIES" >> "$HOST_FILE"
fi

#flush DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder