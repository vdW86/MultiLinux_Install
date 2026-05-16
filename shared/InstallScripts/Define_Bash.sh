# Afhankelijk van de besturing, heb ik een paar kleine verschillen
# Dit ga ik nog toepassen in een later stadium

# Bash aanpassen
cat >> ~/.bashrc <<EOF
source ~/dotfiles/bash/bash_aliases.sh
source ~/dotfiles/bash/bash_extra.sh
EOF

cat >> ~/.bash_profile <<EOF
# Source custom Hyprland autostart
[ -f "$HOME/dotfiles/bash/bash_profile.sh" ] && source "$HOME/dotfiles/bash/bash_profile.sh"
EOF
