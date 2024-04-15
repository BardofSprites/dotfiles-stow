#!/bin/bash

emacsclient -e "$(cat show-agenda.el)"
cat ~/.agenda
