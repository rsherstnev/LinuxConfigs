typeset -A ZSH_HIGHLIGHT_STYLES

DISABLE_AUTO_UPDATE=true
HIST_STAMPS="dd.mm.yyyy"

export ZSH=$HOME/.oh-my-zsh
export HISTFILE=$HOME/.zsh_history
export HTB=/opt/htb
export SAVEHIST=5000
export HISTSIZE=5000
export VISUAL=/usr/bin/nvim
export EDITOR=/usr/bin/nvim
export MANPAGER='less -Mr +Gg'
export ZSH_TMUX_AUTOSTART=true
# Настройки fzf
export FZF_ALT_C_COMMAND="fd --hidden --type d"
export FZF_DEFAULT_OPTS='--bind alt-q:abort --color=pointer:227,hl:131,hl+:131 --no-info'
export FZF_CTRL_R_OPTS='-e --cycle --prompt "Command: " --no-info --layout reverse --height 100% --color=fg:15,hl:9,hl+:9'
export FZF_CTRL_T_OPTS='--preview "bat -n --color=always {}" --bind "ctrl-/:change-preview-window(down|hidden|)"'
# Настройки плагина zsh-syntax-highlighting
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

plugins=(
  git
  sudo
  tmux
  systemd
  httpie
  dirhistory
  fzf  
  docker
  rsync
  python
  pip
  pipenv
  pyenv
  poetry
  aliases
  emoji
  colored-man-pages
  colorize
  command-not-found
  copybuffer
  firewalld
  themes
  thefuck
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias ls='exa --group-directories-first --icons=always --git --color=always'
alias l='ls --oneline'
alias la='ls -a'
alias ll='ls -lh'
alias lla='ll -a'
alias lg='ls --grid'
alias lga='lg -a '
alias llg='ll --grid'
alias llga='llg -a'
alias llm='ll --sort=modified --reverse'
alias llma='llm -a'
alias lt='ls --tree --level 2'
alias lta='lt -a'
alias lx='lla -gUmu@ --changed --time-style="+%H:%M:%S %d.%m.%Y" --color-scale --total-size'
alias cls='clear'
alias clshist='truncate -s 0 $HISTFILE && reset'
alias ip='ip -c'
alias grep='grep --color=auto'
alias http='http --style fruity'
alias less='less -s -M +Gg'
alias listservices='systemctl list-units --type=service'
alias tmux_notify="echo -e '\a'"
alias wfuzz='wfuzz -c'
alias md='mkdir -p'
alias msfconsole='msfconsole --quiet'
alias gdb='gdb --silent'
alias xcopy='xclip -selection clipboard'
alias xpaste='xclip -selection clipboard -o'
alias gh='history | grep'
alias mc='env LANG=ru_RU.UTF-8 mc'
alias sudomc='sudo env LANG=ru_RU.UTF-8 mc'
alias catwithoutcomments='sed -e "/^#/d "'
alias sudo='sudo -E'

# Настройки автодополнения zsh
zstyle ':completion:*' special-dirs false
# Настройки плагина fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Настройки плагина zsh-autosuggestions
bindkey '^ ' autosuggest-accept

# Настройки Shell Prompt
export PROMPT='$FG[224]┌──(%F{29}%D{%T}$FG[224])-[$FG[167]%n$FG[217]@$FG[215]%M$FG[224]]-[$FG[109]%~$FG[224]] $(git_prompt_info)%{$reset_color%}
└─$FG[224]# '
export ZSH_THEME_GIT_PROMPT_PREFIX="$FG[145]git:[$FG[228]"
export ZSH_THEME_GIT_PROMPT_DIRTY="$FG[145]]:[$FG[228]✗$FG[145]] "
export ZSH_THEME_GIT_PROMPT_CLEAN="$FG[145]] "
export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Настройка плагина colored-man-pages
typeset -AHg less_termcap
less_termcap[mb]="${fg_bold[red]}" # 
less_termcap[md]="${fg_bold[green]}" # параметры
less_termcap[me]="${reset_color}"
less_termcap[se]="${reset_color}"
less_termcap[so]="${fg_bold[yellow]}" # строка состояния
less_termcap[ue]="${reset_color}"
less_termcap[us]="${fg_bold[red]}" # аргументы параметров

# Подгрузка кастомных автодополнений для zsh
fpath=(
    $HOME/zsh-custom-completions
    $fpath
)
autoload -Uz compinit
compinit