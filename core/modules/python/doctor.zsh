# uv doctor
if ! (( $+commands[uv] )); then
  ome_error "uv not found — python management unavailable"
  ome_info "  fix: brew install uv"
  return 2
fi

ome_info "uv: $(command uv --version 2>&1 | head -1)"
