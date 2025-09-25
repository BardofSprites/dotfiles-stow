#!/usr/bin/env bash

emacsclient -e "(bard/export-agenda-to-file)"
cat ~/.cache/agenda
