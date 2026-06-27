#!/usr/bin/env bash

echo "=== Bash configuratie ==="

BASHRC="$HOME/.bashrc"
BASHPROFILE="$HOME/.bash_profile"

# --- BASIS SOURCES ---
if ! grep -q "bash_aliases.sh" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" <<EOF

# Custom dotfiles
source \$HOME/dotfiles/bash/bash_aliases.sh
source \$HOME/dotfiles/bash/bash_extra.sh
EOF
fi

# --- DISTRO SPECIFIEKE ALIASES ---
if [ "$SYSTEM" = "opensuse" ]; then
    if ! grep -q "zypper install" "$BASHRC" 2>/dev/null; then
        cat >> "$BASHRC" <<EOF

# Zypper shortcuts
alias pac="sudo zypper install"
alias pacu="sudo zypper dup"
alias psync="sudo zypper refresh"
alias plist="sudo zypper list-updates"
alias paci="zypper info"
alias pacs="sudo zypper search"
alias paco="sudo zypper packages --orphaned"
alias pacr="sudo zypper rm --clean-deps"
alias pacinstalled="zypper se --installed-only | awk '{print \\$3}' | sort"
alias pacinstalledsort="zypper se --installed-only | awk '{print \\$3, \\$5}' | sort -k2 -n | tail -n 20"
EOF
    fi
fi

# --- BASH PROFILE ---
if ! grep -q "bash_profile.sh" "$BASHPROFILE" 2>/dev/null; then
    cat >> "$BASHPROFILE" <<EOF

# Custom profile
[ -f "\$HOME/dotfiles/bash/bash_profile.sh" ] && source "\$HOME/dotfiles/bash/bash_profile.sh"
EOF
fi

echo "✅ Bash configuratie voltooid"
