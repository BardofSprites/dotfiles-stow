#!/bin/sh

# main options
export TERMINAL="/usr/local/bin/st"
export EDITOR="nvim"
export VISUAL="emacsclient -"
export BROWSER=/usr/bin/xdg-open

# environment variables
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH:$PATH"
# scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin/scripts/:$PATH"
export PATH="$HOME/.local/bin/scripts/perl/:$PATH"
export PATH="$HOME/.local/bin/scripts/video-editing/:$PATH"
export PATH="$HOME/.local/bin/scripts/image-editing/:$PATH"
export PATH="$HOME/.local/bin/scripts/status/:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
