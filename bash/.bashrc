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

if [ "$color_prompt" = yes ]; then
    _COLOR1="\[\e[01;38;5;167m\]"
    _COLOR2="\[\e[01;38;5;144m\]"
    _COLOR3="\[\e[01;38;5;216m\]"
    _COLOR4="\[\e[01;38;5;109m\]"
    _COLOR_RESET="\[\e[0m\]"
    if [ "$(id -u)" != "0" ]; then
        PS1="[${_COLOR1}\u${_COLOR2}㉿${_COLOR3}\H ${_COLOR4}\w${_COLOR_RESET}]\n\\$ "
    else
        _ROOT_WARNING="\[\e[01;38;5;160m\]"
        PS1="${_ROOT_WARNING}!!! ROOT !!! ${_COLOR_RESET}[${_COLOR1}\u${_COLOR2}㉿${_COLOR3}\H ${_COLOR4}\w${_COLOR_RESET}]\n\\$ "
    fi 
else
    PS1='[\u@\H \w]\$ '
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
