#!/bin/bash
# Wifi-menu via Fuzzel + nmcli

# Adapter check
ADAPTER=$(nmcli device status | awk '$2=="wifi"{print $1; exit}')
if [ -z "$ADAPTER" ]; then
    notify-send "Wifi-menu" "Geen wifi-adapter gevonden"
    exit 1
fi

# Scan netwerken
nmcli device wifi rescan
networks=$(nmcli -t -f SSID,SIGNAL device wifi list \
    | awk -F: '$1!=""{print $1 ":" $2}' \
    | sort -t: -k1,1 -k2,2nr \
    | awk -F: '!seen[$1]++{print $1 " (" $2 "%)"}')

# Kies netwerk via fuzzel
chosen=$(echo "$networks" | fuzzel --dmenu --prompt "Select WiFi: ")

[ -z "$chosen" ] && exit 0

# Strip signaalsterkte
ssid=$(echo "$chosen" | sed 's/ (.*)//')

# Vraag om wachtwoord via fuzzel (onzichtbare invoer)
password=$(fuzzel --dmenu --password --prompt "Password for $ssid: ")

[ -z "$password" ] && exit 0

# Verbinden
nmcli device wifi connect "$ssid" password "$password"
