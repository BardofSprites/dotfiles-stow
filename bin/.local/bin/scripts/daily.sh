#!/usr/bin/env bash

# Weather information
weather_info="Погода $(curl -s wttr.in/?format="%c+%C+%t+%p\n")"

# Top todos from todo.org file under "Important Stuff"
todos=$(grep -A 100 '^\*\* Important Stuff$' /home/bard/Notes/Org-Roam/todo.org | grep '^\*\*\* TODO' | sed -E 's/^\*\*\* TODO (.+)$/\1/' | sed -E 's/\s*:[^:]+:\s*//g' | sed 's/^/☑ /')
todos_message="Задачи на сегодня:\n${todos}"

# Most recent backup status
backup_log="/mnt/hdd/backup_status.log"
backup_status=$(sed -n '1p; 2,9p' "$backup_log" | tr '\n' '\n')

# Send desktop notification
notify-send -i ~/.local/share/icons/Glass/cup.png "Доброе Утро Данила" "<b>${weather_info}</b>\n${todos_message}\n${backup_status}"
echo -e "Доброе Утро Данила" "${weather_info}\n${todos_message}\n${backup_status}"
