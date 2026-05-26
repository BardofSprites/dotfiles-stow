#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "$WALLPAPER_DIR does not exist"
    exit 1
fi

# Extract all unique tags from filenames
selected_tag=$(find "$WALLPAPER_DIR" -type f -print0 \
    | xargs -0 -n1 bash -c 'grep -oP "\[\K[^\]]+" <<< "$0" | tr "," "\n"' \
    | sed 's/^ *//;s/ *$//' \
    | sort -u \
    | fuzzel --dmenu -p "Select tag: ")
[ -z "$selected_tag" ] && exit 1

# Find wallpapers matching the tag, pick one via nsxiv thumbnail view
selected_wallpaper=$(find "$WALLPAPER_DIR" -type f -regex ".*\[[^]]*${selected_tag}[^]]*\].*" -print0 \
    | xargs -0 nsxiv -t -o)
[ -z "$selected_wallpaper" ] && exit 1

awww img "$selected_wallpaper"
