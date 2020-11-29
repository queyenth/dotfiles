export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(nvim {})+abort' --color"

fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

fgst() {
    is_in_git_repo || return

    local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
        echo "$item" | awk '{print $2}'
    done
    echo
}

cdg_list_echo() {
    cat $1 | sed 's/#.*//g' | sed '/^\s*$/d'
}

cdg_echo() {
    local system_wide_filelist=''
    local user_filelist=''

    if [ -r /etc/cdg_paths ]; then
        system_wide_filelist=$(cdg_list_echo /etc/cdg_paths)
    fi
    if [ -r ~/.cdg_paths ]; then
        user_filelist=$(cdg_list_echo ~/.cdg_paths)
    fi

    echo -e "$system_wide_filelist\n$user_filelist" | sed '/^\s*$/d'
}

cdg() {
    local dest_dir=$(cdg_echo | fzf)
    if [[ $dest_dir != '' ]]; then
        cd "$dest_dir"
    fi
}

acdg() {
    echo $(pwd) >> ~/.cdg_paths
    sort -u ~/.cdg_paths -o ~/.cdg_paths
}
