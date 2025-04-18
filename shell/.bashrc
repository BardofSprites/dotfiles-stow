# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export TERMINAL="/usr/local/bin/st"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin/scripts/:$PATH"
export PATH="$HOME/.local/bin/scripts/perl/:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"
export PATH="$HOME/opt/:$PATH"
export PKG_CONFIG_PATH="$HOME/opt/raylib/lib/pkgconfig/:$PKG_CONFIG_PATH"
export PATH="$HOME/.nimble/bin":$PATH

source "$HOME/.config/fzf/key-bindings.bash"

# HISTORY
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

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

PROMPT_COMMAND='PS1X=$(p="${PWD#${HOME}}"; [ "${PWD}" != "${p}" ] && printf "~";IFS=/; for q in ${p:1}; do printf /${q:0:1}; done; printf "${q:1}")'
GREEN='\[\033[1;32m\]'
PURPLE='\[\033[1;35m\]'
RESET='\[\033[0m\]'

export PS1="${GREEN}\${PS1X} ${PURPLE}λ${RESET} "

# export PS1='\[\e[1m\]\[\e[31m\][\[\e[33m\]\u\[\e[32m\]@\[\e[34m\]\H \[\e[35m\]\w\[\e[31m\]]\[\e[0m\]\[\033[01;35m\] λ\[\033[00m\] '


[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
# . "$HOME/.cargo/env"

PATH="/home/bard/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/bard/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/bard/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/bard/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/bard/perl5"; export PERL_MM_OPT;
