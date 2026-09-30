#
# ~/.zshrc.d/70-tools.zsh
#

export GRC_ALIASES=true
[[ -s /etc/profile.d/grc.sh ]] && source /etc/profile.d/grc.sh

if [[ -n $TILIX_ID || -n $VTE_VERSION ]]; then
  [[ -r /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi

setopt complete_aliases
compdef _kubectl kubectl
(( $+aliases[k] )) && compdef _kubectl k
