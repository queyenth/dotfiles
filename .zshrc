# idk
bindkey "\033[H" beginning-of-line
bindkey "\033[4~" end-of-line

alias vim="nvim"
alias grep="grep --color=auto --exclude-dir=.git"
alias dk="docker"
alias dkc="docker-compose"
alias preview="fzf --preview 'bat --color \"always\" {}'"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection cliboard -o"

alias rec="ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 -f pulse -ac 2 -i default $1"
alias enc_to_webm="ffmpeg -i $1 -acodec libvorbis -aq 7 -ac 2 -qmax 30 -threads 4 $2"
alias webm_to_mp4="ffmpeg -i $1 -threads 4 $2"

export GREP_OPTIONS=""
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export TERM="xterm-256color"

export SYNCTHING="~/syncthing/data/Default/"

export SPICETIFY_INSTALL="/home/q/spicetify-cli"
export PATH="/home/q/dotfiles/scripts:$SPICETIFY_INSTALL:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.firefox ] && source ~/.firefox

eval "$(starship init zsh)"
