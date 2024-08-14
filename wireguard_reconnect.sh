#!/bin/bash

TMP_PATH='/tmp/wireguard_reconnect_previous_ip'
PREVIOUS_IP=''
CURRENT_IP=''
DOMAIN=''

if [ -f "$TMP_PATH" ]; then
  PREVIOUS_IP=$(<"$TMP_PATH")
fi

CURRENT_IP=$(/usr/bin/nslookup "$DOMAIN" | /usr/bin/awk '/^Address: / { print $2 }')

echo "Current IP: $CURRENT_IP"
echo "Previous IP: $PREVIOUS_IP"

echo "$CURRENT_IP" > "$TMP_PATH"

if [ "$CURRENT_IP" != "$PREVIOUS_IP" ]; then
  echo "Restart wg0"
  systemctl restart wg-quick@wg0.service
fi
