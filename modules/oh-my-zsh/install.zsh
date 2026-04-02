# oh-my-zsh module install — copy .zshrc.example if ~/.zshrc doesn't exist
if [[ ! -f "$HOME/.zshrc" ]]; then
  cp "${0:h}/.zshrc.example" "$HOME/.zshrc"
  printf '\033[0;34m[ome]\033[0m Created ~/.zshrc from defaults\n'
fi
