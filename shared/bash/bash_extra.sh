#!/usr/bin/env bash
# --- Bash Extra Configurations ---

# Verschillende PS1 voor verschillende terminals
case "$TERM" in
    *alacritty*)
        PS1="worp> "
        ;;
    *kitty*)
        PS1="\[\e[41m\]   \[\e[48;5;15m\]   \[\e[44m\]   \[\e[m\] > "
        ;;
    *)
        PS1="\u@\h$ "
        ;;
esac

# Voeg dotfiles scripts toe aan PATH
export PATH="$HOME/dotfiles/scripts:$PATH"

# Enable autocd
shopt -s autocd

# Enable color support of ls and grep
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=32:bd=33;01:cd=33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:mi=05;37;41:or=31;01'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- SSH Agent Setup ---
# Start ssh-agent als er nog geen draait en voeg key toe
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY" ]; then
	    if [ -z "$SSH_AUTH_SOCK" ] || ! pgrep -u "$USER" ssh-agent >/dev/null; then
        eval "$(ssh-agent -s)" > /dev/null
    fi
    if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$SSH_KEY" | awk '{print $2}')" ; then
        ssh-add -q "$SSH_KEY"
    fi
fi
