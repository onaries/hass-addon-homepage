#!/bin/sh

OPTIONS_FILE="/data/options.json"
ADDON_CONFIG_DIR="/addon_configs/homepage_dashboard"
APP_CONFIG_DIR="/app/config"

echo "Starting Homepage..."

if [ -f "$OPTIONS_FILE" ]; then
    echo "Running in Home Assistant addon mode..."
    
    PORT=$(jq -r '.port // 3000' "$OPTIONS_FILE")
    ALLOWED_HOSTS=$(jq -r '.allowed_hosts // "*"' "$OPTIONS_FILE")
    RESET_CONFIG=$(jq -r '.reset_config // false' "$OPTIONS_FILE")
    NPM_USERNAME=$(jq -r '.npm_username // empty' "$OPTIONS_FILE")
    NPM_PASSWORD=$(jq -r '.npm_password // empty' "$OPTIONS_FILE")
    PORTAINER_KEY=$(jq -r '.portainer_key // empty' "$OPTIONS_FILE")
    HA_TOKEN=$(jq -r '.homeassistant_token // empty' "$OPTIONS_FILE")
    GITEA_TOKEN=$(jq -r '.gitea_token // empty' "$OPTIONS_FILE")
    SYNOLOGY_USERNAME=$(jq -r '.synology_username // empty' "$OPTIONS_FILE")
    SYNOLOGY_PASSWORD=$(jq -r '.synology_password // empty' "$OPTIONS_FILE")
    UPTIME_SLUG=$(jq -r '.uptime_slug // empty' "$OPTIONS_FILE")
    ADGUARD_USERNAME=$(jq -r '.adguard_username // empty' "$OPTIONS_FILE")
    ADGUARD_PASSWORD=$(jq -r '.adguard_password // empty' "$OPTIONS_FILE")
    KOMODO_URL=$(jq -r '.komodo_url // empty' "$OPTIONS_FILE")
    KOMODO_KEY=$(jq -r '.komodo_key // empty' "$OPTIONS_FILE")
    KOMODO_SECRET=$(jq -r '.komodo_secret // empty' "$OPTIONS_FILE")
    QBIT_URL=$(jq -r '.qbittorrent_url // empty' "$OPTIONS_FILE")
    QBIT_USERNAME=$(jq -r '.qbittorrent_username // empty' "$OPTIONS_FILE")
    QBIT_PASSWORD=$(jq -r '.qbittorrent_password // empty' "$OPTIONS_FILE")
    GITHUB_TOKEN=$(jq -r '.github_token // empty' "$OPTIONS_FILE")
    
    export PORT="$PORT"
    export HOMEPAGE_ALLOWED_HOSTS="$ALLOWED_HOSTS"
    [ -n "$NPM_USERNAME" ] && export HOMEPAGE_VAR_NPM_USERNAME="$NPM_USERNAME"
    [ -n "$NPM_PASSWORD" ] && export HOMEPAGE_VAR_NPM_PASSWORD="$NPM_PASSWORD"
    [ -n "$PORTAINER_KEY" ] && export HOMEPAGE_VAR_PORTAINER_KEY="$PORTAINER_KEY"
    [ -n "$HA_TOKEN" ] && export HOMEPAGE_VAR_HA_TOKEN="$HA_TOKEN"
    [ -n "$GITEA_TOKEN" ] && export HOMEPAGE_VAR_GITEA_TOKEN="$GITEA_TOKEN"
    [ -n "$SYNOLOGY_USERNAME" ] && export HOMEPAGE_VAR_SYNOLOGY_USERNAME="$SYNOLOGY_USERNAME"
    [ -n "$SYNOLOGY_PASSWORD" ] && export HOMEPAGE_VAR_SYNOLOGY_PASSWORD="$SYNOLOGY_PASSWORD"
    [ -n "$UPTIME_SLUG" ] && export HOMEPAGE_VAR_UPTIME_SLUG="$UPTIME_SLUG"
    [ -n "$ADGUARD_USERNAME" ] && export HOMEPAGE_VAR_ADGUARD_USERNAME="$ADGUARD_USERNAME"
    [ -n "$ADGUARD_PASSWORD" ] && export HOMEPAGE_VAR_ADGUARD_PASSWORD="$ADGUARD_PASSWORD"
    [ -n "$KOMODO_URL" ] && export HOMEPAGE_VAR_KOMODO_URL="$KOMODO_URL"
    [ -n "$KOMODO_KEY" ] && export HOMEPAGE_VAR_KOMODO_KEY="$KOMODO_KEY"
    [ -n "$KOMODO_SECRET" ] && export HOMEPAGE_VAR_KOMODO_SECRET="$KOMODO_SECRET"
    [ -n "$QBIT_URL" ] && export HOMEPAGE_VAR_QBIT_URL="$QBIT_URL"
    [ -n "$QBIT_USERNAME" ] && export HOMEPAGE_VAR_QBIT_USERNAME="$QBIT_USERNAME"
    [ -n "$QBIT_PASSWORD" ] && export HOMEPAGE_VAR_QBIT_PASSWORD="$QBIT_PASSWORD"
    [ -n "$GITHUB_TOKEN" ] && export HOMEPAGE_VAR_GITHUB_TOKEN="$GITHUB_TOKEN"
    
    if [ "$RESET_CONFIG" = "true" ] || [ ! -d "$ADDON_CONFIG_DIR" ] || [ -z "$(ls -A $ADDON_CONFIG_DIR 2>/dev/null)" ]; then
        echo "Initializing config at $ADDON_CONFIG_DIR"
        rm -rf "$ADDON_CONFIG_DIR"
        mkdir -p "$ADDON_CONFIG_DIR"
        cp -r /app/config_defaults/* "$ADDON_CONFIG_DIR/"
    fi
    
    rm -rf "$APP_CONFIG_DIR"
    ln -s "$ADDON_CONFIG_DIR" "$APP_CONFIG_DIR"
    echo "Config linked: $ADDON_CONFIG_DIR -> $APP_CONFIG_DIR"
else
    echo "Running in standalone mode..."
    export HOMEPAGE_ALLOWED_HOSTS="*"
    if [ ! -d "$APP_CONFIG_DIR" ] || [ -z "$(ls -A $APP_CONFIG_DIR 2>/dev/null)" ]; then
        mkdir -p "$APP_CONFIG_DIR"
        cp -r /app/config_defaults/* "$APP_CONFIG_DIR/"
    fi
fi

exec node server.js
