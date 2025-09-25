#!/usr/bin/env bash

# Define the available themes
themes=("modus vivendi" "modus operandi tinted" "ef spring" "melissa dark")

# dmenu to prompt the user for i3 theme selection
selected_theme=$(printf "%s\n" "${themes[@]}" | dmenu -p "Select a theme:")

# set the theme in the i3 configuration file
set_theme() {
    sed -i "s/^set \$bg.*$/set \$bg      $1/" ~/.config/i3/colors
    sed -i "s/^set \$fg.*$/set \$fg      $2/" ~/.config/i3/colors
    sed -i "s/^set \$space.*$/set \$space   $3/" ~/.config/i3/colors
    sed -i "s/^set \$red.*$/set \$red     $4/" ~/.config/i3/colors
    sed -i "s/^set \$green.*$/set \$green   $5/" ~/.config/i3/colors
    sed -i "s/^set \$yellow.*$/set \$yellow  $6/" ~/.config/i3/colors
    sed -i "s/^set \$blue.*$/set \$blue    $7/" ~/.config/i3/colors
    sed -i "s/^set \$aqua.*$/set \$aqua    $8/" ~/.config/i3/colors
    sed -i "s/^set \$purple.*$/set \$purple  $9/" ~/.config/i3/colors
    sed -i "s/^set \$border.*$/set \$border  ${10}/" ~/.config/i3/colors
}

# paths for wallpapers per themes
melissa_wallpaper1="/home/bard/Pictures/wallpaper/Landscape/Favourite/yellowshinkansen.jpg "
melissa_wallpaper2="/home/bard/Pictures/wallpaper/Landscape/Favourite/teaworkers.jpg "
vivendi_wallpaper="/home/bard/Pictures/wallpaper/Stoic/dublinlibrary.jpg"
operandi_wallpaper="/home/bard/Pictures/wallpaper/Stoic/downton_abbey.jpg"
spring_wallpaper1="/home/bard/Pictures/wallpaper/Landscape/Favourite/chineselake.jpg"
spring_wallpaper2="/home/bard/Pictures/wallpaper/Art/TeahouseatKoishikawa.jpg"

set_wallpaper() {
    # Set wallpaper for monitor 1
    nitrogen --set-zoom-fill --head=0 --save $1

    # Set wallpaper for monitor 2
    nitrogen --set-zoom-fill --head=1 --save $2

    echo $1
    echo $2
}

# bg, fg. space. red. green, yellow, blue, aqua/cyan, purple, border
case $selected_theme in
    "modus vivendi")
	# set i3 theme
        set_theme "#000000" "#ffffff" "#ffffff" "#ff5f59" "#44bc44" "#fec43f" "#2fafff" "#00d3d0" "#b6a0ff" "#ffffff"
	# set xresources theme
	xrdb -merge /home/bard/Xresources.vivendi
	# set emacs theme
	selected_emacs_theme="modus-vivendi"
	emacsclient -e "(setq command-line-args-left (list \"$selected_emacs_theme\"))" -e "(load-file \"/home/bard/.local/bin/scripts/emacs-theme.el\")"
	# set wallpaper
	set_wallpaper $vivendi_wallpaper $vivendi_wallpaper
        ;;
    "modus operandi tinted")
	# set i3 theme
        set_theme "#fbf7f0" "#000000" "#000000" "#a60000" "#006800" "#6f5500" "#0031a9" "#721045" "#005e8b" "#721045"
	# set xresources theme
	xrdb -merge /home/bard/Xresources.operandi
	# set emacs theme
	selected_emacs_theme="modus-operandi-tinted"
	emacsclient -e "(setq command-line-args-left (list \"$selected_emacs_theme\"))" -e "(load-file \"/home/bard/.local/bin/scripts/emacs-theme.el\")"
	# set wallpaper
	set_wallpaper $operandi_wallpaper $operandi_wallpaper
        ;;
    "ef spring")
	# set i3 theme
        set_theme "#34494a" "#f6fff9" "#f6fff9" "#c42d2f" "#1a870f" "#a45f22" "#375cc6" "#1f6fbf" "#9435b4" "#9d5e7a"
	# set xresources theme
	xrdb -merge /home/bard/Xresources.spring
	# set emacs theme
	selected_emacs_theme="ef-spring"
	emacsclient -e "(setq command-line-args-left (list \"$selected_emacs_theme\"))" -e "(load-file \"/home/bard/.local/bin/scripts/emacs-theme.el\")"
	# set wallpaper
	set_wallpaper $spring_wallpaper1 $spring_wallpaper2
        ;;
    "melissa dark")
	# set i3 theme
	set_theme "#352718" "#e8e4b1" "#e8e4b1" "#ff7f7f" "#6fd560" "#ffa21f" "#57aff6" "#6fcad0" "#f0aac5" "#ffa21f"
	# set xresources theme
	xrdb -merge /home/bard/Xresources.melissa-dark
	# set emacs theme
	selected_emacs_theme="ef-melissa-dark"
	emacsclient -e "(setq command-line-args-left (list \"$selected_emacs_theme\"))" -e "(load-file \"/home/bard/.local/bin/scripts/emacs-theme.el\")"
	# set wallpaper
	set_wallpaper $melissa_wallpaper1 $melissa_wallpaper2
	;;
    *)
        echo "Invalid theme selected."
        ;;
esac

# Reload i3 to apply the changes
i3-msg reload

# restart compositor
killall picom
picom --experimental-backends --daemon
