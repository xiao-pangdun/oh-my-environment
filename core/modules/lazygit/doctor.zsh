# lazygit doctor
if ! (( $+commands[lazygit] )); then
  ome_info "lazygit: not installed"
  ome_info "  install: brew install lazygit"
  return 0
fi

ome_info "lazygit: $(command lazygit --version 2>&1 | head -1)"
