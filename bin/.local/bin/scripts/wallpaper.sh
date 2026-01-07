#!/usr/bin/env bash

# Exit on error
set -e

# Path to the directory containing your wallpapers
WALLPAPER_DIRS="$HOME/Pictures/wallpaper
$HOME/Pictures/other-wallpaper"

# If image is passed as argument, skip selection
if [ -n "$1" ]; then
    selected_wallpaper="$1"

    # Optional: expand ~ and get absolute path
    selected_wallpaper="$(realpath "$selected_wallpaper")"

    if [ ! -f "$selected_wallpaper" ]; then
        echo "Error: File does not exist: $selected_wallpaper"
        exit 1
    fi
else
    WALLPAPER_DIR=$(printf "%s\n" "$WALLPAPER_DIRS" | dmenu -p "Select directory:")

    [ -z "$WALLPAPER_DIR" ] && exit 1

    selected_wallpaper=$(nsxiv -t -r -o "$WALLPAPER_DIR")

    [ -z "$selected_wallpaper" ] && exit 1
fi

# Options for display modes
OPTIONS="Tiled\nZoom Filled\nCentered\nMax"

# Prompt user to select a display mode
selected_mode=$(echo -e "$OPTIONS" | dmenu -p "Select Display Mode:")

# Clean wallpaper cache file
sed -i '/feh/d' $HOME/.cache/wallpaper

# Command to set wallpaper based on selected mode
case "$selected_mode" in
    "Tiled")
        feh --bg-tile "$selected_wallpaper"
        echo "feh --no-fehbg --bg-tile '$selected_wallpaper'" >> ~/.cache/wallpaper
        ;;
    "Zoom Filled")
        feh --no-fehbg --bg-fill "$selected_wallpaper"
        echo "feh --no-fehbg --bg-fill '$selected_wallpaper'" >> ~/.cache/wallpaper
        ;;
    "Centered")
        feh --no-fehbg --bg-center "$selected_wallpaper"
        echo "feh --no-fehbg --bg-center '$selected_wallpaper'" >> ~/.cache/wallpaper
        ;;
    "Max")
        feh --no-fehbg --bg-max "$selected_wallpaper"
        echo "feh --no-fehbg --bg-max '$selected_wallpaper'" >> ~/.cache/wallpaper
        ;;
    *)
        echo "Invalid option selected."
        exit 1
        ;;
esac

echo "Wallpaper set successfully."
