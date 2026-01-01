#!/bin/sh

# The directory where Home Assistant stores configuration
HA_CONFIG_DIR="/config/homepage"
# The directory where the app expects its configuration
APP_CONFIG_DIR="/app/config"

echo "Starting Homepage Add-on..."

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
