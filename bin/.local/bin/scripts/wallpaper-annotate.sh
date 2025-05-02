#!/bin/bash

# Define wallpaper path
WALLPAPER="$HOME/Pictures/wallpaper/Stoic/library_arch.jpg"

# Temporary image file
TMP_WALL="$HOME/.cache/wallpaper_tmp.png"

# Generate the text (Example: 'cal' output)
TEXT_OUTPUT=$(cal)

# Define text position and padding
X_OFFSET=1350
Y_OFFSET=50
PADDING=50
POINTSIZE=30
BOX_COLOR="rgba(0, 0, 0, 0.6)"  # Semi-transparent white

# Get text dimensions
TEXT_WIDTH=$(magick -background none -fill black -pointsize $POINTSIZE label:"$TEXT_OUTPUT" -format "%w" info:)
TEXT_HEIGHT=$(magick -background none -fill black -pointsize $POINTSIZE label:"$TEXT_OUTPUT" -format "%h" info:)

# Calculate box dimensions
BOX_WIDTH=$((TEXT_WIDTH + 2 * PADDING))
BOX_HEIGHT=$((TEXT_HEIGHT + 2 * PADDING))

# Overlay box and text onto wallpaper
magick "$WALLPAPER" \
       -fill "$BOX_COLOR" \
       -draw "rectangle $X_OFFSET,$Y_OFFSET $((X_OFFSET + BOX_WIDTH)),$((Y_OFFSET + BOX_HEIGHT))" \
       -gravity NorthWest -pointsize $POINTSIZE \
       -fill white \
       -font "$HOME/.local/share/fonts/iosevka-comfy-wide-motion-duo-regular.ttf" \
       -annotate +$((X_OFFSET + PADDING))+$(($Y_OFFSET + PADDING + POINTSIZE)) "$TEXT_OUTPUT" \
       "$TMP_WALL"

# Set the new wallpaper
feh --bg-scale "$TMP_WALL"
