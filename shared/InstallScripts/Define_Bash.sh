# Afhankelijk van de besturing, heb ik een paar kleine verschillen

# Bash aanpassen
cat >> ~/.bashrc <<EOF
source ~/dotfiles/bash/bash_aliases.sh
source ~/dotfiles/bash/bash_extra.sh
EOF

if [$SYSTEM = "fedora"]; then
cat >> ~/.bashrc <<EOF

# DNF package shortcuts
alias pac="sudo dnf install"
alias pacu="sudo dnf upgrade"
alias pacs="dnf search"
alias pacc="sudo dnf autoremove"
alias pacr="sudo dnf remove"
alias listpacu="dnf list --installed"
alias pacsco="dnf list --installed | grep"
EOF
elif [$SYSTEM = "opensuse"]; then
cat >> ~/.bashrc <<EOF

# Zypper package shortcuts
alias pac="sudo zypper install"
EOF
else
    echo "Geen systeem geselecteerd. Afsluiten."
    exit 1
fi

cat >> ~/.bash_profile <<EOF
# Source custom Hyprland autostart
[ -f "$HOME/dotfiles/bash/bash_profile.sh" ] && source "$HOME/dotfiles/bash/bash_profile.sh"
EOF
