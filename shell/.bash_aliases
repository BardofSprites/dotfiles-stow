# -*- mode:sh; -*-

alias pyenv="source /home/bard/.pyvenv/bin/activate"
alias comp="picom --daemon"
alias killcomp="killall picom"
alias kd="killall Discord"
alias ta="tmux attach"
alias ts="tmux-sessionizer"
alias rec="ffmpeg -f x11grab -s 1920x1080 -i :0.0+0+0 out.mp4"
alias convert-mp3="ffmpeg -i input.flac -codec:a libmp3lame -qscale:a 0 output.mp3"
alias vim="e"

# playing videos with mpv
function _mf() {
  file=$(find . -type f -printf '%T@ %p\n' 2>/dev/null \
    | sort -nr \
    | cut -d' ' -f2- \
    | fzf -m --reverse)

  [[ -n "$file" ]] && mpv "$file"
}
alias mf='_mf'

function _recentimages() {
    find "$1" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.bmp" \) -printf "%T@ %p\n" |
        sort -nr |
        cut -d" " -f2- |
        nsxiv -t -o -; };

function _recentselect() {
    find "$1" -type f -printf "%T@ %p\n" |
        sort -nr |
        cut -d" " -f2- |
        fzf --reverse --walker=file,dir,follow,hidden --scheme=path -m
}

alias recentimages='_recentimages'
alias select='_recentselect'

function xrdb-theme() {
    local theme_file
    theme_file=$(find ~/.Xresources.d/ -type l | fzf)

    if [[ -n "$theme_file" ]]; then
        xrdb -merge "$theme_file"
        echo "Loaded theme: $(basename "$theme_file")"
    else
        echo "No theme selected."
    fi
}

# gentoo related
alias sysupdate="sudo eix-sync"
alias sysupgrade="sudo emerge --update --deep --newuse @world"

# directory aliases
# cd into the previous working directory by omitting `cd`.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safer default for cp, mv, rm.  These will print a verbose output of
# the operations.  If an existing file is affected, they will ask for
# confirmation.  This can make things a bit more cumbersome, but is a
# generally safer option.
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

# Make ls a bit easier to read.  Note that the -A is the same as -a but
# does not include implied paths (the current dir denoted by a dot and
# the previous dir denoted by two dots).  I would also like to use the
# -p option, which prepends a forward slash to directories, but it does
# not seem to work with symlinked directories. For more, see `man ls`.
alias ls='ls -pv --color=auto --group-directories-first'
alias lsa='ls -pvA --color=auto --group-directories-first'
alias lsl='ls -lhpv --color=auto --group-directories-first'
alias lsla='ls -lhpvA --color=auto --group-directories-first'

# emacs stuff
e() {
    if [ $# -eq 0 ]; then
        emacsclient -c -n -a "nvim" .
    else
        emacsclient -c -n -a "nvim" "$@"
    fi
}

alias catworld="cat /var/lib/portage/world"
