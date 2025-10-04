#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/gruvbox"
CURRENT_WALL=$(hyprctl hyprpaper listloaded | grep -oP 'preloaded: \K[^ ]+')

echo "Current Wallpaper: $CURRENT_WALL"

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
    echo "No new wallpaper found. Exiting."
    exit 1
fi

echo "New Wallpaper: $WALLPAPER"

# Preload the new wallpaper
echo "Preloading wallpaper..."
hyprctl hyprpaper preload "$WALLPAPER"

# Apply the new wallpaper to the monitor
echo "Applying wallpaper to monitor eDP-1..."
hyprctl hyprpaper wallpaper "eDP-1,$WALLPAPER"

echo "Wallpaper changed successfully!"
