#!/bin/bash
# Setup autologin voor getty@tty1 en start Hyprland automatisch

USER_NAME=$(whoami)
OVERRIDE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

echo "🔧 Configuratie voor autologin wordt ingesteld voor gebruiker: $USER_NAME"

# Stap 1: systemd override maken voor autologin
sudo mkdir -p "$OVERRIDE_DIR"

sudo tee "$OVERRIDE_FILE" > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF

echo "✅ Autologin ingesteld in $OVERRIDE_FILE"

# Stap 2: automatisch Hyprland starten bij login
PROFILE="$HOME/.bash_profile"

if [ -n "$ZSH_VERSION" ]; then
  PROFILE="$HOME/.zprofile"
fi

if ! grep -q "exec Hyprland" "$PROFILE" 2>/dev/null; then
  cat >> "$PROFILE" <<'EOL'

# Start Hyprland automatisch op tty1
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec Hyprland
fi
EOL
  echo "✅ Hyprland autostart toegevoegd aan $PROFILE"
else
  echo "ℹ️ Hyprland autostart staat al in $PROFILE"
fi

echo ""
echo "👉 Vergeet niet SDDM uit te schakelen:"
echo "    sudo systemctl disable sddm"
echo ""
echo "Herstart je systeem om autologin + Hyprland autostart te testen."
