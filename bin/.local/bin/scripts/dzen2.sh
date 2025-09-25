#!/usr/bin/env bash

# Set the font and colors
FONT="-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
FG_COLOR="#FFFFFF"
BG_COLOR="#333333"

# Set the Dzen2 geometry (position and size)
GEOMETRY="1920x24+0+0"

# Create the Dzen2 bar with specified settings
dzen2 -fn "$FONT" -fg "$FG_COLOR" -bg "$BG_COLOR" -ta l -w 800 -h 24 -x 0 -y 0 -e "onstart=lower" &
DZEN_PID=$!

# Function to update the Dzen2 bar
update_dzen() {
  while true; do
    DATE=$(date +"%A, %B %d %Y - %H:%M:%S")
    echo -e "$DATE"
    sleep 1
  done
}

# Call the update_dzen function to continuously update the bar
update_dzen | dzen2 -fn "$FONT" -fg "$FG_COLOR" -bg "$BG_COLOR" -x 800 -y 0 -w 1120 -h 24 -ta r -e "onstart=lower"

# Clean up when the script exits
trap "kill $DZEN_PID" EXIT

# Wait for Dzen2 to finish
wait
