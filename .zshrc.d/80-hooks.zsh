#
# ~/.zshrc.d/80-hooks.zsh
#

precmd() {
  local last_command
  last_command=${history[$HISTCMD]}
  [[ -n $last_command ]] && python ~/python/bash_scripts/notifier.py "$last_command"
}
