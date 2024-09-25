typeset -A ZSH_HIGHLIGHT_STYLES

DISABLE_AUTO_UPDATE=true
HIST_STAMPS="dd.mm.yyyy"

export ZSH=$HOME/.oh-my-zsh
export HISTFILE=$HOME/.zsh_history
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
for config_file in $HOME/.{zsh_aliases,zsh_functions}; do
    if [[ -r "$config_file" ]] && [[ -f "$config_file" ]]; then
		source "$config_file"
	fi
done
unset file

# Настройки автодополнения zsh
zstyle ':completion:*' special-dirs false
# Настройки плагина fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Настройки плагина zsh-autosuggestions
bindkey '^ ' autosuggest-accept

# Настройки Shell Prompt
export PROMPT='[%B$FG[167]%n$FG[144]㉿$FG[216]%M $FG[109]%~%f%b] $(git_prompt_info)
%# '
export ZSH_THEME_GIT_PROMPT_PREFIX="%B$FG[145]git:[$FG[228]"
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
    $HOME/.zsh-custom-completions
    $fpath
)
autoload -Uz compinit
compinit