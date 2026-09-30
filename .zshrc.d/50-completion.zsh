#
# ~/.zshrc.d/50-completion.zsh
#

# autoload -Uz compinit && compinit

# if (( $+commands[kubectl] )); then
#   source <(kubectl completion zsh)
#   compdef k=kubectl
# fi

# ~/.zshrc.d/50-completion.zsh

mkdir -p ~/.zsh/completions
fpath=("$HOME/.zsh/completions" $fpath)

if (( $+commands[kubectl] )); then
  local _kc="$HOME/.zsh/completions/_kubectl"
  if [[ ! -s $_kc || $_kc -ot ${commands[kubectl]} ]]; then
    kubectl completion zsh >| "$_kc"
  fi
fi

autoload -Uz compinit
compinit

(( $+commands[kubectl] )) && compdef k=kubectl
