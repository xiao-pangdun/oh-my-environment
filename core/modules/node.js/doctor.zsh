# fnm doctor
if ! (( $+commands[fnm] )); then
  ome_error "fnm not found — node version management unavailable"
  ome_info "  fix: brew install fnm"
  return 2
fi

ome_info "fnm: $(command fnm --version 2>&1 | head -1)"
