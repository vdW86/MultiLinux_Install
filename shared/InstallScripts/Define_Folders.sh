#!/usr/bin/env bash

echo "=== Configureer mappen en symlinks ==="

# Zorg dat standaard XDG mappen bestaan
xdg-user-dirs-update

# Basis paden
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_SOURCE="$DOTFILES_DIR/config"

# --- DOTFILES SYNC ---
echo "Synchroniseer dotfiles..."
mkdir -p "$DOTFILES_DIR"
rsync -av --delete "$SCRIPT_DIR/shared/" "$DOTFILES_DIR/"

# --- SCRIPTS EXECUTABLE MAKEN ---
if [[ -d "$DOTFILES_DIR/scripts" ]]; then
    echo "Maak scripts uitvoerbaar..."
    find "$DOTFILES_DIR/scripts/" -type f -name "*.sh" -exec chmod +x {} \;
fi

# --- CONFIG MAPPING ---
declare -A configs=(
  [alacritty]="alacritty.toml keybinds.toml nordic.toml"
  [fastfetch]="config.jsonc logo.txt"
  [foot]="foot.ini"
  [dunst]="dunstrc"
  [fuzzel]="fuzzel.ini"
  [hypr]="hyprland.conf"
  [kitty]="kitty.conf"
  [swaylock]="config backgrounds"
  [waybar]="config.jsonc style.css"
)

echo "Maak symlinks in ~/.config..."

for app in "${!configs[@]}"; do
    TARGET_DIR="$HOME/.config/$app"
    SOURCE_DIR="$CONFIG_SOURCE/$app"

    echo "→ $app"

    mkdir -p "$TARGET_DIR"

    for file in ${configs[$app]}; do
        SOURCE_FILE="$SOURCE_DIR/$file"
        TARGET_FILE="$TARGET_DIR/$file"

        if [[ -e "$SOURCE_FILE" ]]; then
            ln -sf "$SOURCE_FILE" "$TARGET_FILE"
        else
            echo "⚠️  Bestand ontbreekt: $SOURCE_FILE"
        fi
    done
done

# --- BACKGROUNDS ---
echo "Kopieer backgrounds..."
mkdir -p "$HOME/Pictures/backgrounds"

if [[ -d "$DOTFILES_DIR/backgrounds" ]]; then
    rsync -av --delete "$DOTFILES_DIR/backgrounds/" "$HOME/Pictures/backgrounds/"
else
    echo "⚠️  Geen backgrounds map gevonden in dotfiles"
fi

echo "✅ Configuratie voltooid"

