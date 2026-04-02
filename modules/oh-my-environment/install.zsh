# oh-my-environment module install — copy .omerc.example if ~/.omerc doesn't exist
if [[ ! -f "$HOME/.omerc" ]]; then
  cp "${0:h}/.omerc.example" "$HOME/.omerc"
  printf '\033[0;34m[ome]\033[0m Created ~/.omerc from defaults\n'
fi
