# oh-my-zsh module install — copy .zshrc.example if ~/.zshrc is missing or is the default omz one
if [[ ! -f "$HOME/.zshrc" ]] || grep -qF '# ZSH_CUSTOM=/path/to/new-custom-folder' "$HOME/.zshrc"; then
  cp "${0:h}/.zshrc.example" "$HOME/.zshrc"
  printf '\033[0;34m[ome]\033[0m Created ~/.zshrc from defaults\n'
fi
