#
# ~/.zshrc
#

# GUI terminals are often not login shells, so .zprofile would be skipped
[[ -o login ]] || source ~/.zprofile

[[ -o interactive ]] || return

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"

bindkey -e

for FILE in ~/.zshrc.d/*.zsh(N); do
  [[ -r $FILE ]] && source $FILE
done
