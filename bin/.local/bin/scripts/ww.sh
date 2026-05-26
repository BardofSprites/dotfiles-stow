#!/usr/bin/env bash

# Exit on error
set -e

# Path to the directory containing your wallpapers
WALLPAPER_DIRS="$HOME/Pictures/wallpaper
$HOME/Pictures/other-wallpaper"

# Modern Wayland dmenu replacement
MENU_CMD="fuzzel --dmenu -p"

# If image is passed as argument, skip selection
if [ -n "$1" ]; then
    selected_wallpaper="$1"

    # Expand ~ and get absolute path
    selected_wallpaper="$(realpath "$selected_wallpaper")"

    if [ ! -f "$selected_wallpaper" ]; then
        echo "Error: File does not exist: $selected_wallpaper"
        exit 1
    fi
else
    # Use Wayland menu to select directory
    WALLPAPER_DIR=$(printf "%s\n" "$WALLPAPER_DIRS" | $MENU_CMD "Select directory:")

    [ -z "$WALLPAPER_DIR" ] && exit 1

    # nsxiv picker
    selected_wallpaper=$(xwayland-launch nsxiv -t -r -o "$WALLPAPER_DIR")

    [ -z "$selected_wallpaper" ] && exit 1
fi

awww img "$selected_wallpaper"

echo "Wallpaper set successfully via awww."
