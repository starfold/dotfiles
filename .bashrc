#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=~/bin:$PATH
alias dot='git --git-dir=/home/starfold/Projects/dotfiles/ --work-tree=/home/starfold'
