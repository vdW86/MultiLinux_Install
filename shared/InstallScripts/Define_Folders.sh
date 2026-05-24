# Hier maak ik de mappen aan die ik gebruik, en voeg ik mijn specifieke configs toe
# De configs symlink ik.

# Beginnen met basisfolders in home/user
xdg-user-dirs-update

# Definieer mappen en hun bestanden in één associatieve array
declare -A configs=(
    [alacritty]="alacritty.toml keybinds.toml nordic.toml"
    [fastfetch]="config.jsonc logo.txt"
    [dunst]="dunstrc"
    [fuzzel]="fuzzel.ini"
    [hypr]="hyprland.conf"
    [kitty]="kitty.conf"
    [swaylock]="config backgrounds"
    [waybar]="config.jsonc style.css"
)

# Loop door alle entries: verwijder, maak aan, en symlink in één stap
for map in "${!configs[@]}"; do
    target_dir="$HOME/.config/$map"
    source_dir="$HOME/dotfiles/config/$map"

    # Verwijder de map als deze bestaat
    [ -d "$target_dir" ] && rm -rf "$target_dir"

    # Maak de map aan
    mkdir -p "$target_dir"

    # Symlink alle bestanden (als ze gedefinieerd zijn)
    for file in ${configs[$map]}; do
        [ -n "$file" ] && ln -sf "$source_dir/$file" "$target_dir/$file"
    done
done

# Kopieer gedeelde mappen naar ~/dotfiles/
echo "Kopieer gedeelde mappen naar ~/dotfiles/..."
mkdir -p ~/dotfiles
cp -r "$SCRIPT_DIR/shared/"* ~/dotfiles/

# Kopieer Backgrounds naar Pictures
cp -r "$SCRIPT_DIR/shared/backgrounds" ~/Pictures/
