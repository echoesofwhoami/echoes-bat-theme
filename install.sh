#!/bin/bash

# Echoes Bat Theme Installer
# This script installs the Echoes theme for bat

set -e

echo "Installing Echoes theme for bat..."

# Create themes directory in bat's config directory
THEMES_DIR="$(bat --config-dir)/themes"
mkdir -p "$THEMES_DIR"

# Copy the theme file
cp "Echoes.tmTheme" "$THEMES_DIR/"

# Build bat's cache
echo "Building bat cache..."
bat cache --build

# Verify installation
if bat --list-themes | grep -q "Echoes"; then
    echo "Echoes theme installed successfully!"
    echo ""
    echo "To use the theme, run:"
    echo "  bat --theme=Echoes <file>"
    echo ""
    echo "To make it permanent, add to your shell profile:"
    echo "  export BAT_THEME=\"Echoes\""
    echo ""
    echo "Available themes:"
    bat --list-themes
else
    echo "Theme installation failed"
    exit 1
fi
