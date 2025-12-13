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

if [ -n "$VSCODE_INJECTION" ] || [ "$TERM_PROGRAM" = "vscode" ]; then
    export ZSH_TMUX_AUTOSTART=false
else
    export ZSH_TMUX_AUTOSTART=true
fi

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
    docker-compose
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

tabs -4

# Настройки автодополнения zsh
zstyle ':completion:*' special-dirs false

# Настройки плагина fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Настройки плагина zsh-autosuggestions
bindkey '^ ' autosuggest-accept

color_prompt=yes

local _COLOR1="%%F{001}"     # USERNAME
local _COLOR2="%%F{144}"     # DELIMITER
local _COLOR3="%%F{216}"     # HOSTNAME
local _COLOR4="%%F{109}"     # CURRENT DIR
local _COLOR5="%%F{175}"     # VIRTUAL ENV
local _COLOR6="%%F{001}"     # ROOT WARNING
local _COLOR7="%%F{246}"     # GIT
local _COLOR8="%%F{095}"     # GIT BRANCH
local _COLOR9="%%F{011}"     # GIT DIRTY
local _COLOR10="%%F{144}"    # BOX PROMPT
local _COLOR_RESET="%%f"     # RESET COLOR

# Остаток из плагина ZSH
# export ZSH_THEME_GIT_PROMPT_PREFIX="${_COLOR7}git:(${_COLOR8}"
# export ZSH_THEME_GIT_PROMPT_CLEAN="${_COLOR7})"
# export ZSH_THEME_GIT_PROMPT_DIRTY="${_COLOR7}) ${_COLOR9}X"
# export ZSH_THEME_GIT_PROMPT_SUFFIX="${_COLOR_RESET}"

export VIRTUAL_ENV_DISABLE_PROMPT=1

hackthebox_prompt() {
    if [ -n "$BOX_ADDRESS" ]; then
        if [[ "$color_prompt" = yes ]]; then
            printf "[${_COLOR10}%s${_COLOR_RESET}]─" "$BOX_ADDRESS"
        else
            printf "[%s]─" "$BOX_ADDRESS"
        fi
    fi
}

machine_prompt() {
    if [ -n "$SSH_CONNECTION" ]; then
        printf "[🔗 REMOTE]─"
    else
        printf "[💻 LOCAL]─"
    fi
}

root_prompt() {
    local _ROOT_WARNING="!!! ROOT !!!"

    if [[ $EUID == 0 ]]; then
        if [[ "$color_prompt" = yes ]]; then
            printf "${_COLOR6}[%s]${_COLOR_RESET}─" "${_ROOT_WARNING}"
        else
            printf "[%s]─" "${_ROOT_WARNING}"
        fi
    fi
}

venv_prompt() {
    local _VIRTUAL_ENV_NAME="$(basename "$VIRTUAL_ENV")"

    if [[ "$PWD" = $(dirname "$VIRTUAL_ENV")/* || "$PWD" = "$VIRTUAL_ENV" || "$PWD" = $(dirname "$VIRTUAL_ENV") ]]; then
        if [[ "$color_prompt" = yes ]]; then
            printf "(${_COLOR5}%s${_COLOR_RESET})─" "${_VIRTUAL_ENV_NAME}"
        else
            printf "(%s)─" "${_VIRTUAL_ENV_NAME}"
        fi
    fi
}

user_prompt(){
    local _CURRENT_USER="%n"
    local _DELIMITER="@"
    local _CURRENT_HOSTNAME="%m"

    if [[ "$color_prompt" = yes ]]; then
        printf "(${_COLOR1}%s${_COLOR2}%s${_COLOR3}%s${_COLOR_RESET})─" "${_CURRENT_USER}" "${_DELIMITER}" "${_CURRENT_HOSTNAME}"
    else
        printf "(%s%s%s)─" "${_CURRENT_USER}" "${_DELIMITER}" "${_CURRENT_HOSTNAME}"
    fi
}

home_prompt() {
    if [[ "$PWD" =~ "$HOME" ]]; then
        if [[ "$color_prompt" = yes ]]; then
            printf "[🏡]─"
        else
            printf "[~]─"
        fi
    fi
}

dir_prompt() {
    local _CURRENT_DIR="%~"

    if [[ "$color_prompt" = yes ]]; then
        printf "[${_COLOR4}%s${_COLOR_RESET}]" "${PWD}"
    else
        printf "[%s]" "${PWD}"
    fi
}

git_prompt() {
    local ref
    ref=$(command git symbolic-ref --short HEAD 2> /dev/null) || ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    
    if [[ -n "$ref" ]]; then
        local git_status
        git_status="$(command git status --porcelain 2>/dev/null)"
        
        if [[ -n "$git_status" ]]; then
            if [[ "$color_prompt" = yes ]]; then
                printf " 🌿 ${_COLOR7}(${_COLOR8}%s${_COLOR7}) ${_COLOR9}X${_COLOR_RESET}" "${ref}"
            else
                printf " git:(%s) X" "${ref}"
            fi
        else
            if [[ "$color_prompt" = yes ]]; then
                printf " 🌿 ${_COLOR7}(${_COLOR8}%s${_COLOR7})${_COLOR_RESET}" "${ref}"
            else
                printf " git:(%s)" "${ref}"
            fi
        fi
    fi
}

build_prompt() {
    local _USER_SYMBOL="%#"

    printf "%s" "┌──"
    # printf "%s" "$(hackthebox_prompt)"
    # printf "%s" "$(machine_prompt)"
    printf "%s" "$(root_prompt)"
    printf "%s" "$(venv_prompt)"
    printf "%s" "$(user_prompt)"
    printf "%s" "$(home_prompt)"
    printf "%s" "$(dir_prompt)"
    printf "%s" "$(git_prompt)"
    printf "\n%s" "└─${_USER_SYMBOL} "
}

PROMPT='$(build_prompt)'

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

# Uncomment for ASDF using
# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"