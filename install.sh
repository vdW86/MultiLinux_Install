#!/bin/bash

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

# Controleer of $SYSTEM is ingesteld
if [ -z "$SYSTEM" ]; then
    echo "Geen systeem geselecteerd. Afsluiten."
    exit 1
fi

# hier gaan we beginnen met testen.

# Controleer of $SYSTEM en packs.sh bestaan
if [ ! -f "$SYSTEM/packs.sh" ]; then
    echo "Fout: $SYSTEM/packs.sh niet gevonden."
    exit 1
  else
  echo "Gekozen systeem: $SYSTEM"
  echo "Pakketten installeren met: $PKG_MANAGER"
fi

# Lees packs.sh en installeer elk pakket
while IFS= read -r package; do
    # Sla lege regels over
    if [ -z "$package" ]; then
        continue
    fi
    echo "Installeren: $package"
    $PKG_MANAGER "$package"
done < "$SYSTEM/packs.sh"

echo "Pakketten voor $SYSTEM geïnstalleerd."



echo "Installatie voor $SYSTEM voltooid."
