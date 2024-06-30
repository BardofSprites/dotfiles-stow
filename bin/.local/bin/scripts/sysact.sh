#!/bin/sh

# A dmenu wrapper script for system functions.
export WM="dwm"
case "$(readlink -f /sbin/init)" in
	*systemd*) ctl='systemctl' ;;
	*) ctl='loginctl' ;;
esac

case "$(printf "🔒 lock\n🐻 hibernate\n🔃 reboot\n🧹shutdown\n💤 sleep" | dmenu -i -p 'Action: ')" in
	'🔒 lock') slock ;;
	'🐻 hibernate') slock $ctl hibernate -i ;;
	'💤 sleep') slock $ctl suspend -i ;;
	'🔃 reboot') $ctl reboot -i ;;
	'🖥️shutdown') $ctl poweroff -i ;;
	*) exit 1 ;;
esac
