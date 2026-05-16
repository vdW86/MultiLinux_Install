#!/usr/bin/env bash
# --- User Aliases ---

# Edit scripts/config files quickly
alias basha="vi ~/dotfiles/bash/bash_aliases.sh"
alias bashe="vi ~/dotfiles/bash/bash_extra.sh"
alias bashp="vi ~/dotfiles/bash/bash_profile.sh" 
alias bashrc="vi ~/.bashrc"

# INfo
alias info="fastfetch"					#Info with Fastfetch
alias icpu="lscpu"					#CPU information  
alias ipci="lspci"					#PCI information
alias ibios="sudo dmidecode -t bios"			#BIOS info

# Config editors
alias hypr="vi ~/dotfiles/config/hypr/hyprland.conf"
alias wbar="vi ~/dotfiles/config/waybar/config.jsonc"
alias kit="vi ~/dotfiles/config/waybar/config.jsonc"
alias fuz="vi ~/dotfiles/config/fuzzel/fuzzel.ini"
alias lck="vi ~/dotfiles/scripts/auto_lock.sh"

# Btrfs helpers
alias btdu="sudo btrfs filesystem df /"
alias btuse="sudo btrfs filesystem usage /"
alias btdf='sudo btrfs filesystem usage -h / | grep -E "Device size|Used:|Free "'

# Network/test
alias speed="speedtest-cli --simple"
