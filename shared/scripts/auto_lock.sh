#!/bin/bash
# Lockscreen met vaste achtergrond

# Zorg dat swaylock de juiste Wayland-display ziet
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}

# ---- Config ----
WALL="$HOME/dotfiles/config/swaylock/backgrounds/background.png"
TMP_WALL="/tmp/wall_lock.png"
IDLE_TIMEOUT=300       # seconden voor automatische idle-lock

# ---- Functie om tijdelijke wallpaper met tekst te maken ----
generate_lock_wall() {
    rm -f "$TMP_WALL"
    sleep 0.1

    # Gemiddelde helderheid berekenen
    BRIGHTNESS=$(convert "$WALL" -colorspace Gray -format "%[fx:100*mean]" info:)

    # Kies kleur op basis van helderheid
    if (( $(echo "$BRIGHTNESS > 50" | bc -l) )); then
        COLOR="#FF5555"  # lichte achtergrond → donkere kleur
    else
        COLOR="#FFFFFF"  # donkere achtergrond → lichte kleur
    fi

    # Maak tijdelijke wallpaper
    convert "$WALL" \
        -gravity south \
        -fill "$COLOR" \
        -stroke black \
        -strokewidth 1 \
        -pointsize 40 \
        -annotate +0+50 "Voer wachtwoord in om te ontgrendelen" \
        "$TMP_WALL"

    echo "$COLOR"
}

# ---- Functie om swaylock te starten ----
lock_screen() {
    COLOR=$(generate_lock_wall)
    swaylock \
        --image "$TMP_WALL" \
        --indicator-radius 140 \
        --indicator-thickness 15 \
        --ring-color "$COLOR" \
        --inside-color 00000088 \
        --key-hl-color 33cc33 \
        --text-color "$COLOR" \
        --line-color 00000000 \
        --separator-color 00000000 \
        --indicator-idle-visible \
#        --show-keyboard-layout \
        --show-failed-attempts \
        --daemonize
}

# ---- Hoofd logica ----
if [[ "$1" == "lock_now" ]]; then
    # Handmatig locken
    lock_screen
else
    # Automatisch locken bij idle en bij suspend
    swayidle \
        timeout $IDLE_TIMEOUT "bash -c '$0 lock_now'" \
        before-sleep "bash -c '$0 lock_now'" \
        timeout $((IDLE_TIMEOUT + 300)) 'swaymsg "output * dpms off"'
fi
