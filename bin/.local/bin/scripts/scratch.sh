#!/usr/bin/env bash

modes=("fundamental" "org" "elisp")

selected_mode=$(printf "%s\n" "${modes[@]}" | dmenu -p "Major mode: ")

case $selected_mode in
    "fundamental")
	emacsclient -c -e "(bard/new-plain-buffer)"
	;;
    "org")
	emacsclient -c -e "(bard/new-org-buffer)"
	;;
    "elisp")
	emacsclient -c -e "(bard/new-elisp-buffer)"
	;;
    *)
	echo "Invalid option selected."
	exit 1;
	;;
    esac
