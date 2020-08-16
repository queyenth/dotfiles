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

# Base16 Solarized Light
# Author: Ethan Schoonover (modified by aramisgithub)

_gen_fzf_default_opts() {

local color00='#fdf6e3'
local color01='#eee8d5'
local color02='#93a1a1'
local color03='#839496'
local color04='#657b83'
local color05='#586e75'
local color06='#073642'
local color07='#002b36'
local color08='#dc322f'
local color09='#cb4b16'
local color0A='#b58900'
local color0B='#859900'
local color0C='#2aa198'
local color0D='#268bd2'
local color0E='#6c71c4'
local color0F='#d33682'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

}

_gen_fzf_default_opts
