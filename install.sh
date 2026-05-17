#!/bin/bash
set -e  # Stop bij fouten

# Bepaal de scriptmap
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logbestand: sla alles op in ~/dotfiles_install_<datum-tijd>.log
LOG_FILE="$HOME/dotfiles_install_$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== Start installatie $(date) ==="

# Bevestigingsvraag
read -p "Weet je zeker dat je de installatie wilt starten? (j/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Jj]$ ]]; then
    echo "Installatie afgebroken."
    exit 0
fi

# Kopieer gedeelde mappen naar ~/dotfiles/
echo "Kopieer gedeelde mappen naar ~/dotfiles/..."
mkdir -p ~/dotfiles
cp -r "$SCRIPT_DIR/shared/"* ~/dotfiles/

# Vraag om systeemkeuze
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
        *) echo "Ongeldige keuze. Probeer opnieuw." ;;
    esac
done

# Controleer of $SYSTEM en packs.sh bestaan
if [ ! -f "$SCRIPT_DIR/$SYSTEM/packs.sh" ]; then
    echo "Fout: $SCRIPT_DIR/$SYSTEM/packs.sh niet gevonden."
    exit 1
fi

echo "Gekozen systeem: $SYSTEM"
echo "Pakketten installeren met: sudo $PKG_MANAGER"

# Lees alle pakketten in een array (sla opmerkingen en lege regels over)
mapfile -t packages < <(grep -v '^#' "$SCRIPT_DIR/$SYSTEM/packs.sh" | grep -v '^$' | tr -d '\r')

# Installeer alle pakketten in één commando
if [ ${#packages[@]} -gt 0 ]; then
    echo "Installeren van alle pakketten: ${packages[*]}"
    echo "Opdracht: sudo $PKG_MANAGER ${packages[*]}"

    # Voer het commando uit met sudo en stuur de uitvoer naar terminal + logbestand
    if ! sudo sh -c "$PKG_MANAGER \"${packages[@]}\"" 2>&1 | tee -a "$LOG_FILE"; then
        echo "❌ Fout: Niet alle pakketten konden worden geïnstalleerd. Zie logbestand voor details."
    else
        echo "✅ Alle pakketten geïnstalleerd."
    fi
else
    echo "Geen pakketten gevonden in $SCRIPT_DIR/$SYSTEM/packs.sh"
fi

# Voer extra scripts uit
if [ -f "$SCRIPT_DIR/shared/InstallScripts/Define_Folders.sh" ]; then
#    "$SCRIPT_DIR/shared/InstallScripts/Define_Folders.sh"
else
    echo "Waarschuwing: $SCRIPT_DIR/shared/InstallScripts/Define_Folders.sh niet gevonden."
fi

if [ -f "$SCRIPT_DIR/shared/InstallScripts/Define_Bash.sh" ]; then
 #   "$SCRIPT_DIR/shared/InstallScripts/Define_Bash.sh"
else
    echo "Waarschuwing: $SCRIPT_DIR/shared/InstallScripts/Define_Bash.sh niet gevonden."
fi

echo "=== Installatie voor $SYSTEM voltooid ==="
echo "Je kunt $SCRIPT_DIR nu verwijderen."
