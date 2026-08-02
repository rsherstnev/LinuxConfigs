[[ $- != *i* ]] && return

[[ -t 0 ]] && stty -ixon

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
HISTIGNORE="history:ls:lla:la:ll:cd:clear:cls"
HISTTIMEFORMAT='%d.%m.%Y %H:%M:%S '

shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cmdhist

case "$TERM" in
    xterm-color|*-256color)
        color_prompt=yes
        ;;
esac

# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# \001/\002 = \[ \] для readline (безопасны при сборке PS1 через printf)
_COLOR1=$'\001\e[01;38;5;001m\002'     # USERNAME
_COLOR2=$'\001\e[01;38;5;144m\002'     # DELIMETER
_COLOR3=$'\001\e[01;38;5;216m\002'     # HOSTNAME
_COLOR4=$'\001\e[01;38;5;109m\002'     # CURRENT DIR
_COLOR5=$'\001\e[01;38;5;175m\002'     # VIRTUAL ENV
_COLOR6=$'\001\e[01;38;5;001m\002'     # ROOT WARNING
_COLOR7=$'\001\e[01;38;5;246m\002'     # GIT
_COLOR8=$'\001\e[01;38;5;095m\002'     # GIT BRANCH
_COLOR9=$'\001\e[01;38;5;011m\002'     # GIT DIRTY
_COLOR_RESET=$'\001\e[0m\002'          # RESET COLOR

export VIRTUAL_ENV_DISABLE_PROMPT=1

machine_prompt() {
    if [ -n "$SSH_CONNECTION" ]; then
        printf '[REMOTE]─'
    else
        printf '[LOCAL]─'
    fi
}

root_prompt() {
    local _ROOT_WARNING="!!! ROOT !!!"

    if [[ $EUID == 0 ]]; then
        if [[ "$color_prompt" = yes ]]; then
            printf '%s[%s]%s─' "${_COLOR6}" "${_ROOT_WARNING}" "${_COLOR_RESET}"
        else
            printf '[%s]─' "${_ROOT_WARNING}"
        fi
    fi
}

venv_prompt() {
    [[ -n "$VIRTUAL_ENV" ]] || return 0

    local _VIRTUAL_ENV_NAME
    _VIRTUAL_ENV_NAME="$(basename "$VIRTUAL_ENV")"

    if [[ "$color_prompt" = yes ]]; then
        printf '(%s%s%s)─' "${_COLOR5}" "${_VIRTUAL_ENV_NAME}" "${_COLOR_RESET}"
    else
        printf '(%s)─' "${_VIRTUAL_ENV_NAME}"
    fi
}

user_prompt(){
    local _CURRENT_USER="\u"
    local _DELIMITER="@"
    local _CURRENT_HOSTNAME="\H"

    if [[ "$color_prompt" = yes ]]; then
        printf '(%s%s%s%s%s%s%s)─' \
            "${_COLOR1}" "${_CURRENT_USER}" \
            "${_COLOR2}" "${_DELIMITER}" \
            "${_COLOR3}" "${_CURRENT_HOSTNAME}" \
            "${_COLOR_RESET}"
    else
        printf '(%s%s%s)─' "${_CURRENT_USER}" "${_DELIMITER}" "${_CURRENT_HOSTNAME}"
    fi
}

home_prompt() {
    if [[ "$PWD" == "$HOME" || "$PWD" == "$HOME"/* ]]; then
        printf '[~]─'
    fi
}

dir_prompt() {
    local _CURRENT_DIR="\w"
    local _ABSOLUTE_CURRENT_DIR="${PWD}"

    if [[ "$color_prompt" = yes ]]; then
        printf '[%s%s%s]' "${_COLOR4}" "${_CURRENT_DIR}" "${_COLOR_RESET}"
    else
        printf '[%s]' "${_CURRENT_DIR}"
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
                printf ' %s(%s%s%s) %sX%s' \
                    "${_COLOR7}" "${_COLOR8}" "${ref}" "${_COLOR7}" \
                    "${_COLOR9}" "${_COLOR_RESET}"
            else
                printf ' git:(%s) X' "${ref}"
            fi
        else
            if [[ "$color_prompt" = yes ]]; then
                printf ' %s(%s%s%s)%s' \
                    "${_COLOR7}" "${_COLOR8}" "${ref}" "${_COLOR7}" "${_COLOR_RESET}"
            else
                printf ' git:(%s)' "${ref}"
            fi
        fi
    fi
}

build_prompt() {
    local _USER_SYMBOL="\\$"

    printf "%s" "┌──"
    # printf "%s" "$(machine_prompt)"
    printf "%s" "$(root_prompt)"
    printf "%s" "$(venv_prompt)"
    printf "%s" "$(user_prompt)"
    # printf "%s" "$(home_prompt)"
    printf "%s" "$(dir_prompt)"
    printf "%s" "$(git_prompt)"
    printf "\n%s" "└─${_USER_SYMBOL} "
}

if [[ -n "$CURSOR_AGENT" ]]; then
    PS1='\u@\h:\w\$ '
    PROMPT_COMMAND='history -a; history -c; history -r'
else
    PROMPT_COMMAND='history -a; history -c; history -r; PS1=$(build_prompt)'
fi

# unset color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

for config_file in $HOME/.{aliases,functions}; do
    if [[ -r "$config_file" ]] && [[ -f "$config_file" ]]; then
        source "$config_file"
    fi
done
unset config_file

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    elif [[ -f /usr/local/etc/bash_completion ]]; then
        source /usr/local/etc/bash_completion
    fi
fi

export VISUAL=vim
export EDITOR=vim

# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/lesspipe ] && export LESSOPEN="|lesspipe %s"

export GREP_COLORS='ms=01;33'

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

printf -v EXA_COLORS '%s:' "${EXA_SETTINGS[@]}"
export EXA_COLORS="${EXA_COLORS%:}"

export LESS_TERMCAP_mb=$'\e[1;36m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_mu=$'\e[1;37m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;91m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;36m'

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            source "$rc"
        fi
    done
fi

unset rc

[[ -t 1 ]] && command -v tabs >/dev/null && tabs -4

# TMUX Autostart: отдельные сессии для SSH и локального входа (консоль / эмулятор терминала)
if [ -n "$CURSOR_AGENT" ] || [ -n "$VSCODE_INJECTION" ] || [ "$TERM_PROGRAM" = "vscode" ]; then
    export ZSH_TMUX_AUTOSTART=false
elif [[ -z "$TMUX" ]]; then
    if command -v tmux &> /dev/null; then
        if [ -n "$SSH_CONNECTION" ]; then
            TMUX_SESSION=remote
        else
            TMUX_SESSION=local
        fi
        # -A: attach к существующей сессии или создать новую; exec заменяет оболочку
        exec tmux new-session -A -s "$TMUX_SESSION"
    fi
fi

# Если приглашение к вводу пустое - вставить "sudo !!" для повтора предыдущей команды от root
# Если приглашение к вводу не начинается с "sudo", то добавить его в начало
# Если приглашение к вводу начинается с "sudo", то убрать его из начала
_prepend_sudo() {
    if [[ -z "$READLINE_LINE" ]]; then
        READLINE_LINE="sudo !!";
        READLINE_POINT=${#READLINE_LINE}
    else
        if [[ "$READLINE_LINE" == sudo\ * ]]; then
            READLINE_LINE="${READLINE_LINE#sudo }"
            READLINE_POINT=$(( READLINE_POINT > 5 ? READLINE_POINT - 5 : 0 ))
        else
            READLINE_LINE="sudo $READLINE_LINE"
            READLINE_POINT=$(( READLINE_POINT + 5 ))
        fi
    fi
}

bind -x '"\e\e": _prepend_sudo'
