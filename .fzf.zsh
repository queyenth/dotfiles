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

_gen_fzf_default_opts() {

local color00='#fbf1c7'
local color01='#ebdbb2'
local color02='#d5c4a1'
local color03='#bdae93'
local color04='#665c54'
local color05='#504945'
local color06='#3c3836'
local color07='#282828'
local color08='#9d0006'
local color09='#af3a03'
local color0A='#b57614'
local color0B='#79740e'
local color0C='#427b58'
local color0D='#076678'
local color0E='#8f3f71'
local color0F='#d65d0e'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

}

_gen_fzf_default_opts
