case $- in
    *i*) ;;
      *) return;;
esac

HISTSIZE=10000
HISTFILESIZE=10000
HISTIGNORE="history:ls:lla:la:ll:cd:clear:cls"
HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cmdhist

PROMPT_COMMAND='history -a'

export MANPAGER="/usr/bin/most -s"
export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
   PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\][\u@\H]\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\[\033[01;31m\]➤\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}[\u@\h] \w\n➤'
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
