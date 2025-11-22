[[ $- != *i* ]] && return

stty -ixon

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
HISTIGNORE="history:ls:lla:la:ll:cd:clear:cls"
HISTTIMEFORMAT='%d.%m.%Y %H:%M:%S '

shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cmdhist

PROMPT_COMMAND='history -a'

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

VIRTUAL_ENV_DISABLE_PROMPT=0

_COLOR1="\e[01;38;5;001m"
_COLOR2="\e[01;38;5;144m"
_COLOR3="\e[01;38;5;216m"
_COLOR4="\e[01;38;5;109m"
_COLOR5="\e[01;38;5;175m"
_COLOR6="\e[01;38;5;001m"
_COLOR_RESET="\e[0m"

# WHERE_I_AM() {
#     if [ -n "$SSH_CONNECTION" ]; then
#         echo "[🔗 REMOTE]-"
#     else
#         echo "[💻 LOCAL]-"
#     fi
# }

if [ "$color_prompt" = yes ]; then
    VENV_PROMPT() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
            printf "%b" "(${_COLOR5}$(basename $VIRTUAL_ENV)${_COLOR_RESET})─";
        fi
    }
    ROOT_WARNING="${_COLOR6}[!!! ROOT !!!]${_COLOR_RESET}─"
    if [[ $EUID != 0 ]]; then
        PS1="┌──\$(VENV_PROMPT)(${_COLOR1}\u${_COLOR2}@${_COLOR3}\H${_COLOR_RESET})─[${_COLOR4}\w${_COLOR_RESET}]\n└─\\$ "
    else
        PS1="┌──${ROOT_WARNING}\$(VENV_PROMPT)(${_COLOR1}\u${_COLOR2}@${_COLOR3}\H${_COLOR_RESET})─[${_COLOR4}\w${_COLOR_RESET}]\n└─\\$ "
    fi 
else
    VENV_PROMPT() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
            printf "%b" "($(basename $VIRTUAL_ENV))─";
        fi
    }
    ROOT_WARNING="[!!! ROOT !!!]─"
    if [[ $EUID != 0 ]]; then
        PS1="┌──\$(VENV_PROMPT)(\u@\H)─[\w]\n└─\\$ "
    else
        PS1="┌──${ROOT_WARNING}\$(VENV_PROMPT)(\u@\H)─[\w]\n└─\\$ "
    fi
fi

unset color_prompt force_color_prompt

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

if [[ -d /etc/bash_completion.d/ ]]; then
    for file in /etc/bash_completion.d/* ; do
        source "$file"
    done
fi

export VISUAL=vim
export EDITOR=vim

# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/lesspipe ] && export LESSOPEN="|lesspipe %s"

export GREP_COLORS='ms=01;33'

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

tabs -4

# TMUX Autostart
if [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
    if command -v tmux &> /dev/null; then
        tmux attach-session || tmux
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