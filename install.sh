#!/usr/bin/env bash
set -e

USER_HOME=$(eval echo ~$USER)
BIN_DIR="$USER_HOME/.local/bin"
CONF_DIR="$USER_HOME/.config/caelestia-gamemode"
SERVICE_FILE="$USER_HOME/.config/systemd/user/caelestia-gamemode.service"

mkdir -p "$BIN_DIR" "$USER_HOME/.config/systemd/user" "$CONF_DIR"

# Default config
mkdir -p "$CONF_DIR"
[[ -f "$CONF_DIR/patterns.conf" ]] || printf '%s\n' 'steam-launch-wrapper' 'reaper SteamLaunch' 'minecraft' >~/.config/caelestia-gamemode/patterns.conf

echo "Installed config into ~/.config/caelestia-gamemode/patterns.conf"
echo "To find out how to use it, look on README.md"

# Watcher
cat >"$BIN_DIR/caelestia-gamemode" <<'EOF'
#!/usr/bin/env bash
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/caelestia-gamemode/patterns.conf"
INTERVAL=2
STOP_GRACE=3

running() {
    local p
    while IFS= read -r p; do
        [[ -z $p || $p == \#* ]] && continue
        pgrep -f -- "$p" >/dev/null && return 0
    done < "$CONF"
    return 1
}

active=0; misses=0
while sleep "$INTERVAL"; do
    if running; then
        misses=0
        if (( !active )); then
            qs -c caelestia ipc call gameMode enable
            active=1
        fi
    elif (( active )); then
        if (( ++misses >= STOP_GRACE )); then
            qs -c caelestia ipc call gameMode disable
            active=0; misses=0
        fi
    fi
done
EOF
chmod +x "$BIN_DIR/caelestia-gamemode"

echo "Installed watcher into $BIN_DIR/caelestia-gamemode"

# Systemd service
printf "[Unit]\nDescription=Caelestia Gamemode service\nPartOf=default.service\nAfter=default.target\n\n[Service]\nExecStart=%s/caelestia-gamemode\nRestart=always\nRestartSec=3\n\n[Install]\nWantedBy=graphical-session.target\n" "$BIN_DIR" >"$SERVICE_FILE"

echo "Installed systemd service in $SERVICE_FILE"

systemctl --user daemon-reload
systemctl --user enable --now caelestia-gamemode
