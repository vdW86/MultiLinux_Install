#!/bin/bash
set -e  # Stop direct bij fouten

# Logbestand: sla alles op in ~/dotfiles_install.log
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
cp -r shared/backgrounds ~/dotfiles/
cp -r shared/bash ~/dotfiles/
cp -r shared/scripts ~/dotfiles/
cp -r shared/config ~/dotfiles/

# Vraag om systeemkeuze
PS3="Voor welk systeem wil je installeren? "
options=("opensuse" "fedora" "Afsluiten")
select opt in "${options[@]}"; do
    case $opt in
        "opensuse")
            SYSTEM="opensuse"
            PKG_MANAGER="sudo zypper install -y"
            break
            ;;
        "fedora")
            SYSTEM="fedora"
            PKG_MANAGER="sudo dnf install -y"
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
if [ ! -f "$SYSTEM/packs.sh" ]; then
    echo "Fout: $SYSTEM/packs.sh niet gevonden."
    exit 1
fi

echo "Gekozen systeem: $SYSTEM"
echo "Pakketten installeren met: $PKG_MANAGER"

# Installeer pakketten
while IFS= read -r package; do
    if [ -z "$package" ]; then
        continue
    fi
    echo "Installeren: $package"
    if ! $PKG_MANAGER "$package"; then
        echo "Fout: Kon pakket '$package' niet installeren."
    fi
done < "$SYSTEM/packs.sh"

# Voer subscripts uit (vanuit ~/MultiLinux_Install/)
echo "Voer extra scripts uit..."
./shared/InstallScripts/Define_Folders.sh
./shared/InstallScripts/Define_Bash.sh

echo "=== Installatie voor $SYSTEM voltooid ==="
echo "Je kunt ~/MultiLinux_Install/ nu verwijderen."
