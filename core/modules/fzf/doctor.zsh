# fzf doctor
if ! (( $+commands[fzf] )); then
  ome_info "fzf: not installed"
  ome_info "  install: brew install fzf"
  return 0
fi

ome_info "fzf: $(command fzf --version 2>&1 | head -1)"
