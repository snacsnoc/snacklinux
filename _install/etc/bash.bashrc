# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Export location of terminfo so we don't get unkown terminal type errors
export TERMINFO=/share/terminfo

# Set our prompt
PS1='[\[\033[01;32m\]\h\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\$ '

PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'

# Yay colours
alias ls='ls --color=auto'
