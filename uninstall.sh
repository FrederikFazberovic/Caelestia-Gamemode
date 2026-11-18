#!/usr/bin/env bash

USER_HOME="$HOME"
BIN_DIR="$USER_HOME/.local/bin"
CONF_DIR="$USER_HOME/.config/caelestia-gamemode"
SERVICE_FILE="$USER_HOME/.config/systemd/user/caelestia-gamemode.service"

echo "Stopping and disabling systemd service..."
systemctl --user stop --now caelestia-gamemode
systemctl --user disable --now caelestia-gamemode
rm -f "$SERVICE_FILE"

echo "Removing watcher..."
rm -f "$BIN_DIR/caelestia-gamemode"

echo "Removing config..."
rm -rf "$CONF_DIR"

echo "Reloading systemd daemon..."
systemctl --user daemon-reload

echo "Uninstallation complete."
