autoload -U compinit promptinit
compinit
promptinit; prompt gentoo

zstyle ':completion::complete:*' use-cache 1

# options
setopt AUTO_CD # only type dir to cd somewhere
setopt CORRECT # correct dir typos
setopt NO_CLOBBER # don't overwrite stuff with >
setopt SHARE_HISTORY # share across all open terminal
REPORTTIME=5 # print time for commands > 5 sec

# history
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt inc_append_history

# autocomplete
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

# prompt
precmd() {
    local p="${PWD#$HOME}"
    local out=""
    [ "$PWD" != "$p" ] && out="~"

    if [ -n "${p:1}" ]; then
        local IFS=/
        local parts=(${=p:1})
        local n=${#parts[@]}
        for ((i = 1; i < n; i++)); do
            out+="/${parts[i]:0:1}"
        done
        out+="/${parts[n]}"
    fi

    PS1X="$out"
}

RED='%B%F{red}'
GREEN='%B%F{green}'
YELLOW='%B%F{yellow}'
BLUE='%B%F{blue}'
PURPLE='%B%F{magenta}'
CYAN='%B%F{cyan}'
RESET='%f%b'

setopt PROMPT_SUBST
export PS1="${GREEN}\${PS1X} ${PURPLE}λ${RESET} "


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# load alias file
if [ -f ~/.config/zsh/.zsh_aliases ]; then
    . ~/.config/zsh/.zsh_aliases
fi

# main options
export TERMINAL="/usr/local/bin/st"
export EDITOR="nvim"
export VISUAL="emacsclient -"
export BROWSER=/usr/bin/xdg-open

# environment variables
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"
# scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin/scripts/:$PATH"
export PATH="$HOME/.local/bin/scripts/perl/:$PATH"
export PATH="$HOME/.local/bin/scripts/video-editing/:$PATH"
export PATH="$HOME/.local/bin/scripts/image-editing/:$PATH"
export PATH="$HOME/.local/bin/scripts/status/:$PATH"
export PATH="$HOME/.cargo/bin/:$PATH"

# load plugins
source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/key-bindings.zsh
source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh

bindkey -M viins '^F' autosuggest-accept
