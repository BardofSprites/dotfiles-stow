# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export TERMINAL="/usr/local/bin/st"
export PATH="/home/bard/.local/bin:$PATH"
export PATH="/home/bard/.local/scripts/bin:$PATH"
export PATH="$HOME/opt/:$PATH"
export PKG_CONFIG_PATH="$HOME/opt/raylib/lib/pkgconfig/:$PKG_CONFIG_PATH"
export PATH="$HOME/.nimble/bin":$PATH

# HISTORY
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50
HISTFILESIZE=200

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# simple function to check if installed
_checkexec ()
{
    command -v "$1" > /dev/null
}
# editors
# Default editor.
if pgrep -x emacs > /dev/null
then
    export VISUAL="emacsclient -c"
    export EDITOR="emacsclient -t"
elif _checkexec gvim
then
    export VISUAL="gvim"
    export EDITOR=vim
else
    export VISUAL=vim
    export EDITOR=$VISUAL
fi

# function for count number of certain filetype
countype()
{
    ls -a *.$1 | wc -l
}

# Default browser.  This leverages the MIME list.
export BROWSER=/usr/bin/xdg-open

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\[\033[01;35m\] λ\[\033[00m\] '

[ -f "/home/bard/.ghcup/env" ] && source "/home/bard/.ghcup/env" # ghcup-env
. "$HOME/.cargo/env"
