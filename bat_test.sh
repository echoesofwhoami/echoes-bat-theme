#!/bin/bash

# Determine the actual bat command (bat or batcat)
BAT_CMD="bat"
if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
    BAT_CMD="batcat"
fi

# Get the directory of this script to locate the theme file reliably
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_FILE="$SCRIPT_DIR/Echoes.tmTheme"

if [[ ! -f "$THEME_FILE" ]]; then
    echo "Error: Echoes.tmTheme not found in $SCRIPT_DIR"
    exit 1
fi

# 1. Copy the theme file to the bat config directory
THEMES_DIR="$($BAT_CMD --config-dir)/themes"
mkdir -p "$THEMES_DIR"
cp "$THEME_FILE" "$THEMES_DIR/"

# 2. Rebuild the cache (silently to not clutter the output)
$BAT_CMD cache --build >/dev/null 2>&1

# 3. Execute bat with the Echoes theme and forward all arguments
exec $BAT_CMD --theme=Echoes "$@"