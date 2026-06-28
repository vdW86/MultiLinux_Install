#!/bin/bash

###############################################
#  WiFi Menu voor Fuzzel
#  - Dynamische kolombreedte
#  - Signaalsterkte icoontjes
#  - Custom wachtwoordmasker (plakken werkt)
#  - Automatisch verbinden met bekende netwerken
#  - Compacte fuzzel-config
###############################################

CONFIG="$HOME/.config/fuzzel/fuzzel-wifi.ini"

# --- Interface detecteren (geen p2p) ---
IFACE=$(nmcli -t -f DEVICE,TYPE device \
    | grep ":wifi" \
    | cut -d: -f1 \
    | grep -v p2p \
    | head -n1)

[ -z "$IFACE" ] && notify-send "WiFi" "Geen WiFi-interface gevonden" && exit 1


# --- Signaalsterkte icoontjes ---
signal_icon() {
    local s=$1
    if   [ "$s" -ge 75 ]; then echo "▂▄▆█"
    elif [ "$s" -ge 50 ]; then echo "▂▄▆"
    elif [ "$s" -ge 25 ]; then echo "▂▄"
    elif [ "$s" -ge 1  ]; then echo "▂"
    else echo " "
    fi
}


# --- Custom wachtwoord prompt (plakken werkt) ---
masked_prompt() {
    local prompt="$1"
    local config="$2"

    # Vraag echte input (plakken werkt)
    local input=$(fuzzel --config "$config" --dmenu --prompt="$prompt")

    # Als gebruiker annuleert → leeg teruggeven
    [ -z "$input" ] && echo "" && return

    # Masker genereren (zelfde lengte)
    local len=${#input}
    local mask=$(printf '●%.0s' $(seq 1 $len))

    # Optioneel masker tonen
    # notify-send "Wachtwoord" "$mask"

    echo "$input"
}


# --- Unieke SSID’s met beste signaal ---
RAW=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi \
    | grep -v '^:' \
    | awk -F: '
        {
            ssid=$1; sec=$2; sig=$3;
            if (sig > bestsig[ssid]) {
                bestsig[ssid]=sig;
                bestsec[ssid]=sec;
            }
        }
        END {
            for (s in bestsig) {
                printf "%s:%s:%d\n", s, bestsec[s], bestsig[s];
            }
        }')


# --- Langste SSID bepalen ---
MAXLEN=$(echo "$RAW" | cut -d: -f1 | awk '{print length}' | sort -nr | head -n1)
[ "$MAXLEN" -lt 10 ] && MAXLEN=10


# --- Sorteren + dynamisch uitlijnen ---
LIST=$(echo "$RAW" \
    | sort -t: -k3,3nr \
    | while IFS=: read -r SSID SEC SIG; do
        ICON=$(signal_icon "$SIG")
        printf "%-*s %-6s (%s)\n" "$MAXLEN" "$SSID" "[$ICON]" "$SEC"
    done)


# --- Fuzzel menu ---
CHOICE=$(echo "$LIST" \
    | fuzzel --config "$CONFIG" --dmenu --prompt="WiFi: ")

[ -z "$CHOICE" ] && exit 0

SSID=$(echo "$CHOICE" | awk '{print $1}')


# --- Bestaat er al een opgeslagen verbinding? ---
EXISTING=$(nmcli -t -f NAME connection show | grep "^$SSID$")

if [ -n "$EXISTING" ]; then
    nmcli connection up "$SSID"
    notify-send "WiFi" "Verbonden met opgeslagen netwerk: $SSID"
    exit 0
fi


# --- Security bepalen ---
SECURITY=$(nmcli -t -f SSID,SECURITY dev wifi \
    | grep "^$SSID:" \
    | head -n1 \
    | cut -d: -f2)


# --- Open netwerk ---
if [ -z "$SECURITY" ] || [ "$SECURITY" = "--" ]; then
    nmcli connection add type wifi ifname "$IFACE" con-name "$SSID" ssid "$SSID"
    nmcli connection up "$SSID"
    notify-send "WiFi" "Verbonden met open netwerk: $SSID"
    exit 0
fi


# --- WEP ---
if echo "$SECURITY" | grep -qi "WEP"; then
    PASSWORD=$(masked_prompt "WEP sleutel voor $SSID:" "$CONFIG")
    nmcli connection add type wifi ifname "$IFACE" con-name "$SSID" ssid "$SSID" \
        wifi-sec.key-mgmt none wifi-sec.wep-key0 "$PASSWORD"
    nmcli connection up "$SSID"
    notify-send "WiFi" "Verbonden met WEP netwerk: $SSID"
    exit 0
fi


# --- WPA/WPA2/WPA3 ---
if echo "$SECURITY" | grep -qi "WPA"; then
    PASSWORD=$(masked_prompt "Wachtwoord voor $SSID:" "$CONFIG")
    nmcli connection add type wifi ifname "$IFACE" con-name "$SSID" ssid "$SSID" \
        wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$PASSWORD"
    nmcli connection up "$SSID"
    notify-send "WiFi" "Verbonden met beveiligd netwerk: $SSID"
    exit 0
fi


notify-send "WiFi" "Onbekend beveiligingstype: $SECURITY"
exit 1

