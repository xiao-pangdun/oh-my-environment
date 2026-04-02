# vim module install — copy .vimrc.example if ~/.vimrc doesn't exist
(( $+commands[vim] )) || return 0

if [[ ! -f "$HOME/.vimrc" ]]; then
  cp "${0:h}/.vimrc.example" "$HOME/.vimrc"
  printf '\033[0;34m[ome]\033[0m Created ~/.vimrc from defaults\n'
fi
