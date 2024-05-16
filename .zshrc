source ~/.zgen/zgen.zsh

if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/docker-compose
    zgen oh-my-zsh plugins/pass
    zgen oh-my-zsh plugins/fd
    zgen oh-my-zsh plugins/gulp
    zgen oh-my-zsh plugins/ripgrep
    zgen oh-my-zsh plugins/urltools
    zgen oh-my-zsh themes/clean

    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions src

    zgen save
fi

alias vim="nvim"
alias grep="grep --color=auto --exclude-dir=.git"
alias ls="ls --color=auto"
alias dk="docker"
alias dkc="docker-compose"
alias preview="fzf --preview 'bat --color \"always\" {}'"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection cliboard -o"

alias rec="ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 -f pulse -ac 2 -i default $1"
alias enc_to_webm="ffmpeg -i $1 -acodec libvorbis -aq 7 -ac 2 -qmax 30 -threads 4 $2"
alias webm_to_mp4="ffmpeg -i $1 -threads 4 $2"

alias img-optimize="/home/q/.img-optimize/optimize.sh"

alias rr="curl -s -L http://bit.ly/10hA8iC | bash"

alias cal="cal -m"

export GREP_OPTIONS=""
export EDITOR="mg"
export MANPAGER="nvim +Man!"
export TERM="xterm-256color"

export SYNCTHING="~/syncthing/data/Default/"

export SPICETIFY_INSTALL="/home/q/spicetify-cli"
export DENO_INSTALL="/home/q/.deno"
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export PATH="/home/q/dotfiles/scripts:/home/q/.local/bin:$SPICETIFY_INSTALL:$DENO_INSTALL/bin:$PATH"
export UID="$(id -u)"
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM=wayland

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#eval "$(starship init zsh)"
