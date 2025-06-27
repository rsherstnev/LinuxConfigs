typeset -A ZSH_HIGHLIGHT_STYLES

DISABLE_AUTO_UPDATE=true
HIST_STAMPS="%d.%m.%Y %H:%M:%S"

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
# Настройки grep
export GREP_COLORS='ms=01;33'
# Настройки exa
export EXA_COLORS=""
EXA_PREFIX="1;38;5" # Жирный кастомный цвет
EXA_R="107" # Цвет: полномочие чтения
EXA_W="131" # Цвет: полномочие записи
EXA_X="172" # Цвет: полномочие исполнения
EXA_SETTINGS=(
    "ur=$EXA_PREFIX;$EXA_R" # Полномочие чтения пользователя
    "uw=$EXA_PREFIX;$EXA_W" # Полномочие записи пользователя
    "ux=$EXA_PREFIX;$EXA_X" # Полномочие исполнения пользователя для обычных файлов
    "ue=$EXA_PREFIX;$EXA_X" # Полномочие исполнения пользователя для других файлов
    "gr=$EXA_PREFIX;$EXA_R" # Полномочие чтения группы
    "gw=$EXA_PREFIX;$EXA_W" # Полномочие записи группы
    "gx=$EXA_PREFIX;$EXA_X" # Полномочие исполнения группы
    "tr=$EXA_PREFIX;$EXA_R" # Полномочие чтения для иных
    "tw=$EXA_PREFIX;$EXA_W" # Полномочие записи для иных
    "tx=$EXA_PREFIX;$EXA_X" # Полномочие исполнения для иных
    "uu=$EXA_PREFIX;65" # Ваш пользотватель
    "uR=$EXA_PREFIX;124" # Пользователь root
    "un=$EXA_PREFIX;142" # Пользователь не ваш и не root
    "gu=$EXA_PREFIX;65" # Ваша группа
    "gR=$EXA_PREFIX;124" # Группа root
    "gn=$EXA_PREFIX;142" # Группа не ваша и не root
    "da=$EXA_PREFIX;60" # Дата файла
    "di=$EXA_PREFIX;31" # Тип сущности: директория
    "ex=$EXA_PREFIX;$EXA_X" # Тип сущности: исполняемый файл
    "bd=$EXA_PREFIX;217" # Тип сущности: блочное устройство
    "cd=$EXA_PREFIX;229" # Тип сущности: символьное устройство
    "ln=$EXA_PREFIX;73" # Тип сущности: симлинк
    "xa=$EXA_PREFIX;96" # Индикатор расширенных аттрибутов
)
for EXA_SETTING in ${EXA_SETTINGS[*]}
do
    export EXA_COLORS=$EXA_COLORS:$EXA_SETTING
done

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
    aliases
    emoji
    colored-man-pages
    colorize
    command-not-found
    copybuffer
    firewalld
    themes
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

for config_file in $HOME/.{aliases,functions}; do
    if [[ -r "$config_file" ]] && [[ -f "$config_file" ]]; then
		source "$config_file"
	fi
done
unset config_file

# Настройки автодополнения zsh
zstyle ':completion:*' special-dirs false
# Настройки плагина fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Настройки плагина zsh-autosuggestions
bindkey '^ ' autosuggest-accept

# Настройки Shell Prompt
export HTB_ADDRESS=""

HTB_PROMPT() {
    if [[ -n "$HTB_ADDRESS" ]]; then
        echo "%B$FG[184][🥝 $HTB_ADDRESS]$RESET_PROMPT─"
    fi
}

VENV_PROMPT() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%B$FG[036]($(basename "$VIRTUAL_ENV"))$RESET_PROMPT─"
    fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
export RESET_PROMPT="%{$reset_color%}"
export PROMPT='┌──$(HTB_PROMPT)$(VENV_PROMPT)[%B$FG[167]%n$FG[144]㉿$FG[216]%M$RESET_PROMPT]─[$FG[109]%~%f%b]$(git_prompt_info)
└─%# '
export ZSH_THEME_GIT_PROMPT_PREFIX="─%B$FG[145][git:$FG[011]"
export ZSH_THEME_GIT_PROMPT_DIRTY="$FG[145]]:[$FG[011]🔴$FG[145]] "
export ZSH_THEME_GIT_PROMPT_CLEAN="$FG[145]] "
export ZSH_THEME_GIT_PROMPT_SUFFIX=$RESET_PROMPT

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

if [ -d $HOME/.python-custom-completions ]; then
    for completion_file in $HOME/.python-custom-completions/*; do
        if [ -f "$completion_file" ]; then
            source "$completion_file"
        fi
    done
fi
unset completion_file

zstyle ':completion:*:ssh:*' hosts
zstyle ':completion:*:ssh:*' config ~/.ssh/config
zstyle ':completion:*:ssh:*' known-hosts ~/.ssh/known_hosts

eval "$(uv generate-shell-completion zsh)"