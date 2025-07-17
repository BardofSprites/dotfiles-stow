#!/bin/bash


# Path to the directory containing your wallpapers
WALLPAPER_DIRS="$HOME/Pictures/wallpaper/\n$HOME/Pictures/other-wallpaper/"

WALLPAPER_DIR=$(echo -e "$WALLPAPER_DIRS" | dmenu -p "Select directory: ")

if [ -z "$WALLPAPER_DIR" ]; then
    exit 1
fi

# Use nsxiv to mark an image
selected_wallpaper=$(nsxiv -t -r -o $WALLPAPER_DIR)

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
