#!/bin/sh

OPTIONS_FILE="/data/options.json"
ADDON_CONFIG_DIR="/addon_configs/homepage_dashboard"
APP_CONFIG_DIR="/app/config"

echo "Starting Homepage..."

export HOMEPAGE_ALLOWED_HOSTS="*"

if [ -f "$OPTIONS_FILE" ]; then
    echo "Running in Home Assistant addon mode..."
    
    PORT=$(jq -r '.port // 3000' "$OPTIONS_FILE")
    NPM_USERNAME=$(jq -r '.npm_username // empty' "$OPTIONS_FILE")
    NPM_PASSWORD=$(jq -r '.npm_password // empty' "$OPTIONS_FILE")
    PORTAINER_KEY=$(jq -r '.portainer_key // empty' "$OPTIONS_FILE")
    HA_TOKEN=$(jq -r '.homeassistant_token // empty' "$OPTIONS_FILE")
    GITEA_TOKEN=$(jq -r '.gitea_token // empty' "$OPTIONS_FILE")
    SYNOLOGY_USERNAME=$(jq -r '.synology_username // empty' "$OPTIONS_FILE")
    SYNOLOGY_PASSWORD=$(jq -r '.synology_password // empty' "$OPTIONS_FILE")
    
    export PORT="$PORT"
    [ -n "$NPM_USERNAME" ] && export HOMEPAGE_VAR_NPM_USERNAME="$NPM_USERNAME"
    [ -n "$NPM_PASSWORD" ] && export HOMEPAGE_VAR_NPM_PASSWORD="$NPM_PASSWORD"
    [ -n "$PORTAINER_KEY" ] && export HOMEPAGE_VAR_PORTAINER_KEY="$PORTAINER_KEY"
    [ -n "$HA_TOKEN" ] && export HOMEPAGE_VAR_HA_TOKEN="$HA_TOKEN"
    [ -n "$GITEA_TOKEN" ] && export HOMEPAGE_VAR_GITEA_TOKEN="$GITEA_TOKEN"
    [ -n "$SYNOLOGY_USERNAME" ] && export HOMEPAGE_VAR_SYNOLOGY_USERNAME="$SYNOLOGY_USERNAME"
    [ -n "$SYNOLOGY_PASSWORD" ] && export HOMEPAGE_VAR_SYNOLOGY_PASSWORD="$SYNOLOGY_PASSWORD"
    
    if [ ! -d "$ADDON_CONFIG_DIR" ] || [ -z "$(ls -A $ADDON_CONFIG_DIR 2>/dev/null)" ]; then
        echo "Initializing config at $ADDON_CONFIG_DIR"
        mkdir -p "$ADDON_CONFIG_DIR"
        cp -r /app/config_defaults/* "$ADDON_CONFIG_DIR/"
    fi
    
    rm -rf "$APP_CONFIG_DIR"
    ln -s "$ADDON_CONFIG_DIR" "$APP_CONFIG_DIR"
    echo "Config linked: $ADDON_CONFIG_DIR -> $APP_CONFIG_DIR"
else
    echo "Running in standalone mode..."
    if [ ! -d "$APP_CONFIG_DIR" ] || [ -z "$(ls -A $APP_CONFIG_DIR 2>/dev/null)" ]; then
        mkdir -p "$APP_CONFIG_DIR"
        cp -r /app/config_defaults/* "$APP_CONFIG_DIR/"
    fi
fi

exec node server.js
