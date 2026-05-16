#!/usr/bin/env bash
# --- User specific environment and startup programs ---

# Start Hyprland automatisch op tty1
if [[ -z "$DISPLAY" ]] && [[ $(tty) == "/dev/tty1" ]]; then
    # Num Lock aanzetten
    setleds -D +num < /dev/tty1
    # Start lock script op de achtergrond
#    bash "$HOME/dotfiles/scripts/auto_lock.sh" &

    # Start Hyprland
    exec /usr/bin/Hyprland
fi

# Alias om GNOME op TTY3 te starten
alias start-gdm='~/dotfiles/scripts/GNOME/start-gnome.sh'
