#!/usr/bin/env bash
set -euo pipefail

# === SCRIPT DIRECTORY ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === LOGGING ===
LOG_DIR="$HOME/install_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_$(date +%Y-%m-%d_%H-%M-%S).log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Start installatie $(date) ==="

# === CONFIRM ===
read -rp "Weet je zeker dat je de installatie wilt starten? (j/n): " -n 1
echo

if [[ ! $REPLY =~ ^[Jj]$ ]]; then
    echo "Installatie afgebroken."
    exit 0
fi

# === DISTRO SELECTIE ===
PS3="Voor welk systeem wil je installeren? "
options=("opensuse" "fedora" "Afsluiten")

select opt in "${options[@]}"; do
    case $opt in
        "opensuse")
            SYSTEM="opensuse"
            PKG_MANAGER="zypper install -y"
            break
            ;;
        "fedora")
            SYSTEM="fedora"
            PKG_MANAGER="dnf install -y"
            break
            ;;
        "Afsluiten")
            echo "Installatie afgebroken."
            exit 0
            ;;
        *)
            echo "Ongeldige keuze."
            ;;
    esac
done

export SYSTEM
export SCRIPT_DIR

echo "Gekozen systeem: $SYSTEM"

# === PACKAGE FILE CHECK ===
PACKAGE_DIR="$SCRIPT_DIR/$SYSTEM/packages"

if [[ ! -f "$PACK_FILE" ]]; then
    echo "Fout: $PACK_FILE niet gevonden."
    exit 1
fi

# === PACKAGES INLEZEN ===
packages=()

for file in "$PACKAGE_DIR"/*.sh; do
    echo "Inlezen: $(basename "$file")"

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^# ]] || [[ -z "$line" ]]; then
            continue
        fi

        line=$(echo "$line" | tr -d '\r' | xargs)
        packages+=("$line")

    done < "$file"

done
# === INSTALLEREN ===
if [[ ${#packages[@]} -gt 0 ]]; then
    echo "Installeren van pakketten..."
    sudo $PKG_MANAGER "${packages[@]}"
else
    echo "Geen pakketten gevonden."
fi

# === SHARED SCRIPTS ===
run_script () {
    local script="$1"

    if [[ -f "$script" ]]; then
        echo "Voer $(basename "$script") uit..."
        source "$script"
    else
        echo "Waarschuwing: $script niet gevonden."
    fi
}

run_script "$SCRIPT_DIR/shared/InstallScripts/Define_Folders.sh"
run_script "$SCRIPT_DIR/shared/InstallScripts/Define_Bash.sh"
run_script "$SCRIPT_DIR/shared/InstallScripts/setup-autologin.sh"

echo "=== Installatie voltooid ==="
