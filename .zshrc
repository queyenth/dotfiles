# Created by newuser for 5.7.1
source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/bower
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/docker

    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions src

    zgen load jackharrisonsherlock/common common

    zgen save
fi
alias vim="nvim"
alias grep="grep --color=auto --exclude-dir=.git"
alias dk="docker"
alias dkc="docker-compose"
alias preview="fzf --preview 'bat --color \"always\" {}'"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection cliboard -o"

alias rec="ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 -f pulse -ac 2 -i default $1"
alias enc_to_webm="ffmpeg -i $1 -acodec libvorbis -aq 7 -ac 2 -qmax 30 -threads 2 $2"

export GREP_OPTIONS=""
export EDITOR="nvim"
export TERM="xterm-256color"

export PATH=$PATH:~/.local/bin:~/scripts:~/go/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
