# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL:+:}erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)    color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    tmux-256color)  color_prompt=yes;;
    screen)         color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    # ┌─[<username>@<hostname>]─[pwd> (branch)]─[YYYY/MM/DD HH:MM:SS]
    # └─[$] 
   color_decoration="\[\e[0;34m\]" 
   color_user="\[\e[1;32m\]"
   color_at="\[\e[1;30m\]"
   color_dir="\[\e[1;36m\]"
   color_time="\[\e[1;36m\]" 
   color_git="\[\e[1;35m\]" 
   color_symbol="\[\e[0;31m\]"
   color_host="\[\e[0;32m\]"
   color_reset="\[\e[m\]"
   prompt_symbol="$"
   PS1="${color_decoration}(${color_time}\t${color_decoration}) ${color_decoration}${color_user}\u${color_at}@${color_host}\h${color_decoration}:${color_dir}\w${color_git}"'$(__git_ps1)'"${color_decoration}>\n${color_symbol}${prompt_symbol}${color_decoration}${color_reset} "

else
    PS1="\h\$ "
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -r /home/ishii/.byobu/prompt ] && . /home/ishii/.byobu/prompt   #byobu-prompt#

if [ -f ~/.bashrc_local ] ; then
    . ~/.bashrc_local
fi

source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash
