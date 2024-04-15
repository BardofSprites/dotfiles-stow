#!/bin/bash

# Path to the directory containing your wallpapers
WALLPAPER_DIRS="$HOME/Pictures/wallpaper/\n$HOME/Pictures/Anime-Wallpaper/"

WALLPAPER_DIR=$(echo -e "$WALLPAPER_DIRS" | dmenu -p "Select directory: ")

# Use nsxiv to mark an image
selected_wallpaper=$(nsxiv -t -r -o $WALLPAPER_DIR)

# Options for display modes
OPTIONS="Tiled\nZoom Filled\nCentered"

# Prompt user to select a display mode
selected_mode=$(echo -e "$OPTIONS" | dmenu -p "Select Display Mode:")

# Command to set wallpaper based on selected mode
case "$selected_mode" in
    "Tiled")
        feh --bg-tile "$selected_wallpaper"
        ;;
    "Zoom Filled")
        feh --bg-fill "$selected_wallpaper"
        ;;
    "Centered")
        feh --bg-center "$selected_wallpaper"
        ;;
    *)
        echo "Invalid option selected."
        exit 1
        ;;
esac

echo "Wallpaper set successfully."
