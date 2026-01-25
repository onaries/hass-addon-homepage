#!/bin/sh

# The directory where Home Assistant stores configuration
HA_CONFIG_DIR="/config/homepage"
# The directory where the app expects its configuration
APP_CONFIG_DIR="/app/config"
# Home Assistant addon options file
OPTIONS_FILE="/data/options.json"

echo "Starting Homepage Add-on..."

# Load secrets from addon options and export as HOMEPAGE_VAR_*
if [ -f "$OPTIONS_FILE" ]; then
    echo "Loading secrets from addon configuration..."
    
    NPM_USERNAME=$(jq -r '.npm_username // empty' "$OPTIONS_FILE")
    NPM_PASSWORD=$(jq -r '.npm_password // empty' "$OPTIONS_FILE")
    PORTAINER_KEY=$(jq -r '.portainer_key // empty' "$OPTIONS_FILE")
    HA_TOKEN=$(jq -r '.homeassistant_token // empty' "$OPTIONS_FILE")
    GITEA_TOKEN=$(jq -r '.gitea_token // empty' "$OPTIONS_FILE")
    SYNOLOGY_USERNAME=$(jq -r '.synology_username // empty' "$OPTIONS_FILE")
    SYNOLOGY_PASSWORD=$(jq -r '.synology_password // empty' "$OPTIONS_FILE")
    
    [ -n "$NPM_USERNAME" ] && export HOMEPAGE_VAR_NPM_USERNAME="$NPM_USERNAME"
    [ -n "$NPM_PASSWORD" ] && export HOMEPAGE_VAR_NPM_PASSWORD="$NPM_PASSWORD"
    [ -n "$PORTAINER_KEY" ] && export HOMEPAGE_VAR_PORTAINER_KEY="$PORTAINER_KEY"
    [ -n "$HA_TOKEN" ] && export HOMEPAGE_VAR_HA_TOKEN="$HA_TOKEN"
    [ -n "$GITEA_TOKEN" ] && export HOMEPAGE_VAR_GITEA_TOKEN="$GITEA_TOKEN"
    [ -n "$SYNOLOGY_USERNAME" ] && export HOMEPAGE_VAR_SYNOLOGY_USERNAME="$SYNOLOGY_USERNAME"
    [ -n "$SYNOLOGY_PASSWORD" ] && export HOMEPAGE_VAR_SYNOLOGY_PASSWORD="$SYNOLOGY_PASSWORD"
    
    echo "Secrets loaded successfully."
fi

# 1. Initialize configuration if it doesn't exist
if [ ! -d "$HA_CONFIG_DIR" ]; then
    echo "Creating persistent configuration directory at $HA_CONFIG_DIR"
    mkdir -p "$HA_CONFIG_DIR"
    # Copy default configs from the image to the persistent volume
    cp -rn /app/config_defaults/* "$HA_CONFIG_DIR/"
fi

# 2. Ensure the app uses the persistent volume
# Remove the existing config directory/link and create a new symlink
rm -rf "$APP_CONFIG_DIR"
ln -s "$HA_CONFIG_DIR" "$APP_CONFIG_DIR"

echo "Configuration linked to $HA_CONFIG_DIR"

# 3. Start the original homepage application
# Based on the official homepage image, the entry point is node server.js
exec node server.js
