typeset -A ZSH_HIGHLIGHT_STYLES

export ZSH=$HOME/.oh-my-zsh
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=5000
export HISTSIZE=5000
export VISUAL=/usr/bin/nvim
export EDITOR=/usr/bin/nvim
export MANPAGER='less -s -M +Gg'
export FZF_DEFAULT_OPTS='--bind alt-q:abort --color=pointer:227,hl:131,hl+:131 --no-info'
export FZF_CTRL_R_OPTS='-e --cycle --prompt "Command: " --no-info --layout reverse --height 100% --color=fg:15,hl:9,hl+:9'
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=160'
export ZSH_HIGHLIGHT_STYLES[builtin]='fg=107'
export ZSH_HIGHLIGHT_STYLES[precommand]='fg=107,underline'
export ZSH_HIGHLIGHT_STYLES[command]='fg=107'
export ZSH_HIGHLIGHT_STYLES[global-alias]='fg=107'
export ZSH_HIGHLIGHT_STYLES[alias]='fg=107'
export ZSH_HIGHLIGHT_STYLES[function]='fg=107'
export ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=107'
export ZSH_HIGHLIGHT_STYLES[arg0]='fg=107'
export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=208'
export ZSH_HIGHLIGHT_STYLES[globbing]='fg=174'
export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=227'
export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=227'
export ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=125'
export ZSH_HIGHLIGHT_STYLES[path]='fg=248,underline'

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
plugins=(git sudo tmux systemd nmap httpie dirhistory fzf fzf-tab zsh-autosuggestions zsh-syntax-highlighting docker rsync pip)

alias l='ls -A --color=auto'
alias ls='ls -A --color=auto'
alias la='ls -aA --color=auto'
alias ll='ls -lA --color=auto'
alias lla='ls -laA --color=auto'
alias cls='clear'
alias clsh='truncate -s 0 $HISTFILE && reset'
alias ip='ip -c'
alias grep='grep --color=auto'
alias http='http --style fruity'
alias less='less -s -M +Gg'
alias listservices='systemctl list-units --type=service'
alias tmuxbell="echo -e '\a'"
alias ffuf='ffuf -c'
alias wfuzz='wfuzz -c'
alias md='mkdir -p'
alias sc='systemctl'
alias ipt='iptables'
alias iptlist='iptables -L -n --line-numbers'
alias ip6t='ip6tables'
alias ip6tlist='ip6tables -L -n --line-numbers'
alias msfconsole='msfconsole --quiet'
alias gdb='gdb --silent'
alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'
alias htb='cd /opt/htb'

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
compinit /usr/share/zsh/functions/Completion/Unix/*

export PROMPT='$FG[167]%n$FG[217]@$FG[215]%M $FG[109]%~ $(git_prompt_info)$FG[146]#%{$reset_color%} '
export ZSH_THEME_GIT_PROMPT_PREFIX="$FG[145]git:($FG[226]"
export ZSH_THEME_GIT_PROMPT_DIRTY="$FG[145]) $FG[226]✗"
export ZSH_THEME_GIT_PROMPT_CLEAN="$FG[145])"
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

source $HOME/.venvtools
