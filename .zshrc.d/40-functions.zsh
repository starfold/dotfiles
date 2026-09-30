#
# ~/.zshrc.d/40-functions.zsh
#

mkcd() {
  mkdir -p "$1" && cd "$1"
}

path() {
  print -l ${(s.:.)PATH}
}

fmt_bytes() { numfmt --to=iec --suffix=B --format='%.2f' -- "$1"; }
