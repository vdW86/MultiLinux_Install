#!/bin/bash

# Vraag om systeemkeuze
PS3="Welk packs.sh-bestand wil je controleren? "
options=("opensuse" "fedora" "Afsluiten")
select opt in "${options[@]}"; do
    case $opt in
        "opensuse")
            SYSTEM="opensuse"
            break
            ;;
        "fedora")
            SYSTEM="fedora"
            break
            ;;
        "Afsluiten")
            exit 0
            ;;
        *) echo "Ongeldige keuze. Probeer opnieuw." ;;
    esac
done

# Controleer of het bestand bestaat
if [ ! -f "$SYSTEM/packs.sh" ]; then
    echo "Fout: $SYSTEM/packs.sh niet gevonden."
    exit 1
fi

# Maak een output-bestand aan
OUTPUT_FILE="$SYSTEM_packs_checked.txt"
echo "Controleer $SYSTEM/packs.sh en schrijf resultaat naar $OUTPUT_FILE..."

# Lees elke regel en schrijf deze letterlijk naar het output-bestand
while IFS= read -r line || [ -n "$line" ]; do
    echo "$line" >> "$OUTPUT_FILE"
done < "$SYSTEM/packs.sh"

echo "Klaar! Je kunt nu $OUTPUT_FILE bekijken."
