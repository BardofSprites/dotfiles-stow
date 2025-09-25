#!/usr/bin/env bash

# Set paths
SOURCE_DIRS=(
    "/home/bard/Pictures/"
    "/home/bard/Documents/"
    "/home/bard/Code/"
    "/home/bard/Notes/"
    "/home/bard/Playlists/"
    "/home/bard/Repositories/"
    "/home/bard/Music/"
    "/home/bard/Videos/"
    "/home/bard/dotfiles-stow/"
    "/home/bard/Mail/"
    "/home/bard/Calibre Library/"
    "/home/bard/Boox/"
)

DESTINATION_BASE="/mnt/hdd/"
LOG_FILE="/mnt/hdd/backup.log"
LOG_STATUS_FILE="/mnt/hdd/backup_status.log"
ICON_PATH="/usr/share/icons/gnome/16x16/devices/drive-harddisk.png"

# Log start time
echo "Backup started at $(date)" >> "$LOG_FILE"
notify-send -i $ICON_PATH "Backup started at $(date)"

# Run rsync for each source directory
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
  DESTINATION_DIR="$DESTINATION_BASE$(basename "$SOURCE_DIR")"
  rsync -avuP "$SOURCE_DIR" "$DESTINATION_DIR" >> "$LOG_FILE" 2>&1
  # rsync -avuPn "$SOURCE_DIR" "$DESTINATION_DIR" >> "$LOG_FILE" 2>&1
done

# Display summary made for notifications
NOTIF_SUMMARY=""
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
  DESTINATION_DIR="$DESTINATION_BASE$(basename "$SOURCE_DIR")"
  BACKUP_SIZE=$(du -sh "$DESTINATION_DIR" | cut -f1)
  NOTIF_SUMMARY+="$(basename "$SOURCE_DIR"): $BACKUP_SIZE\n"
done

# Display summary made for log file
LOG_SUMMARY=""
for SOURCE_DIR in "${SOURCE_DIRS[@]}"; do
  DESTINATION_DIR="$DESTINATION_BASE$(basename "$SOURCE_DIR")"
  BACKUP_SIZE=$(du -sh "$DESTINATION_DIR" | cut -f1)
  LOG_SUMMARY+="$(basename "$SOURCE_DIR"): $BACKUP_SIZE\n"
done

# Log end time and display completion message with summary
echo -e "\nBackup Summary:\n$NOTIF_SUMMARY" >> "$LOG_FILE"
notify-send -i "$ICON_PATH" "Backup completed at $(date)" "$NOTIF_SUMMARY"
echo -e "Most recent backup $(date)\n$LOG_SUMMARY" >> "$LOG_STATUS_FILE"
