# starship doctor
if ! (( $+commands[starship] )); then
  ome_error "starship not found — customized prompt unavailable"
  ome_info "  fix: brew install starship"
  return 2
fi

ome_info "starship: $(command starship --version 2>&1 | head -1)"

if [[ ! -f "$HOME/.config/starship.toml" ]]; then
  ome_warn "starship.toml not found — using default config"
  ome_info "  fix: cp $OME_HOME/core/modules/starship/starship.toml.example ~/.config/starship.toml"
fi
