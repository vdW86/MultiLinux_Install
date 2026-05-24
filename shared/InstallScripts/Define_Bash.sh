# Afhankelijk van de besturing, heb ik een paar kleine verschillen

# Bash aanpassen
cat >> ~/.bashrc <<EOF
source ~/dotfiles/bash/bash_aliases.sh
source ~/dotfiles/bash/bash_extra.sh
EOF

if [ "$SYSTEM" = "fedora" ]; then
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
elif [ "$SYSTEM" = "opensuse" ]; then
cat >> ~/.bashrc <<EOF

# Zypper package shortcuts
alias pac="sudo zypper install" # Installeren van pakketten
alias pacu="sudo zypper dup"
alias psync="sudo zypper refresh" # update bronnen
alias plist="sudo zypper list-updates"
alias paci="zypper info"
alias pacs="sudo zypper search"
alias paco="sudo zypper packages --orphaned"	# Identifying orphaned packages
alias pacr="sudo zypper rm --clean-deps"
#alias pacc="sudo zypper"
alias pacinstalled="zypper se --installed-only | awk '{print $3}' | sort" # Lijst van alle pakketten (gesorteerd op naam)
alias pacinstalledsort="zypper se --installed-only | awk '{print $3, $5}' | sort -k2 -n | tail -n 20" # Top 20 grootste pakketten (op schijfruimte)
EOF
else
    echo "Geen systeem geselecteerd. Afsluiten."
    exit 1
fi

cat >> ~/.bash_profile <<EOF
# Source custom Hyprland autostart
[ -f "$HOME/dotfiles/bash/bash_profile.sh" ] && source "$HOME/dotfiles/bash/bash_profile.sh"
EOF
