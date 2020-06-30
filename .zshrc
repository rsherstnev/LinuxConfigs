export ZSH_THEME="norden"
export ZSH="/home/elliot/.oh-my-zsh"
export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=5000
export HISTSIZE=5000
export MANPAGER='less -s -M +Gg'
export TERM=xterm-256color
export FZF_DEFAULT_OPTS='--bind alt-q:abort'
export FZF_CTRL_R_OPTS='-e --cycle --prompt "Command: " --no-info --layout reverse --height 100% --color=fg:15,hl:9,hl+:9'

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt NOTIFY
setopt AUTOCD

HISTORY_IGNORE="(history|ls|la|ll|lla|cd|clear|cls)"
plugins=(git sudo tmux systemd nmap httpie dirhistory fzf fzf-tab zsh-autosuggestions pip pipenv docker rsync zsh-syntax-highlighting)

alias l='ls -A --color=auto'
alias ls='ls -A --color=auto'
alias la='ls -aA --color=auto'
alias ll='ls -lA --color=auto'
alias lla='ls -laA --color=auto'
alias cls='clear'
alias clsh='truncate -s 0 $HISTFILE && reset'
alias ip='ip -c'
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias grepi='grep -i --color=auto'
alias egrepi='grep -E -i --color=auto'
alias fgrepi='grep -F -i --color=auto'
alias http='http --style fruity'
alias less='less -s -M +Gg'
alias rowsandcolumns='stty -a | head -n1 | cut -d ";" -f 2-3 | cut -b2- | sed "s/; /\n/"'
alias listservices='systemctl list-units --type=service'
alias nmapscripts="locate -r '\.nse$' | xargs grep categories"
alias prp='pipenv run python'
alias tmuxbell="echo -e '\a'"
# alias ffuf='ffuf -c'
# alias wfuzz='wfuzz -c'
# alias -g mpad='mousepad'
# alias -g medusa='medusa -b'
# alias -g vim='nvim'
alias -g md='mkdir -p'
alias -g sc='systemctl'
alias -g ipt='iptables'
alias -g iptlist='iptables -L -n --line-numbers'
alias -g ip6t='ip6tables'
alias -g ip6tlist='ip6tables -L -n --line-numbers'
alias -g msfconsole='msfconsole --quiet'
alias -g gdb='gdb --silent'
alias -g xcopy='xclip -selection clipboard'
alias -g xpaste='xclip -selection clipboard -o'
alias -g starwars='beep -l 350 -f 392 -D 100 --new -l 350 -f 392 -D 100 --new -l 350 -f 392 -D 100 --new -l 250 -f 311.1 -D 100 --new -l 25 -f 466.2 -D 100 --new -l 350 -f 392 -D 100 --new -l 250 -f 311.1 -D 100 --new -l 25 -f 466.2 -D 100 --new -l 700 -f 392 -D 100 --new -l 350 -f 587.32 -D 100 --new -l 350 -f 587.32 -D 100 --new -l 350 -f 587.32 -D 100 --new -l 250 -f 622.26 -D 100 --new -l 25 -f 466.2 -D 100 --new -l 350 -f 369.99 -D 100 --new -l 250 -f 311.1 -D 100 --new -l 25 -f 466.2 -D 100 --new -l 700 -f 392 -D 100 --new -l 350 -f 784 -D 100 --new -l 250 -f 392 -D 100 --new -l 25 -f 392 -D 100 --new -l 350 -f 784 -D 100 --new -l 250 -f 739.98 -D 100 --new -l 25 -f 698.46 -D 100 --new -l 25 -f 659.26 -D 100 --new -l 25 -f 622.26 -D 100 --new -l 50 -f 659.26 -D 400 --new -l 25 -f 415.3 -D 200 --new -l 350 -f 554.36 -D 100 --new -l 250 -f 523.25 -D 100 --new -l 25 -f 493.88 -D 100 --new -l 25 -f 466.16 -D 100 --new -l 25 -f 440 -D 100 --new -l 50 -f 466.16 -D 400 --new -l 25 -f 311.13 -D 200 --new -l 350 -f 369.99 -D 100 --new -l 250 -f 311.13 -D 100 --new -l 25 -f 392 -D 100 --new -l 350 -f 466.16 -D 100 --new -l 250 -f 392 -D 100 --new -l 25 -f 466.16 -D 100 --new -l 700 -f 587.32 -D 100 --new -l 350 -f 784 -D 100 --new -l 250 -f 392 -D 100 --new -l 25 -f 392 -D 100 --new -l 350 -f 784 -D 100 --new -l 250 -f 739.98 -D 100 --new -l 25 -f 698.46 -D 100 --new -l 25 -f 659.26 -D 100 --new -l 25 -f 622.26 -D 100 --new -l 50 -f 659.26 -D 400 --new -l 25 -f 415.3 -D 200 --new -l 350 -f 554.36 -D 100 --new -l 250 -f 523.25 -D 100 --new -l 25 -f 493.88 -D 100 --new -l 25 -f 466.16 -D 100 --new -l 25 -f 440 -D 100 --new -l 50 -f 466.16 -D 400 --new -l 25 -f 311.13 -D 200 --new -l 350 -f 392 -D 100 --new -l 250 -f 311.13 -D 100 --new -l 25 -f 466.16 -D 100 --new -l 300 -f 392.00 -D 150 --new -l 250 -f 311.13 -D 100 --new -l 25 -f 466.16 -D 100 --new -l 700 -f 392'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[38;5;113m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;167;1m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh
zstyle ':completion:*' special-dirs false
bindkey '^ ' autosuggest-accept
