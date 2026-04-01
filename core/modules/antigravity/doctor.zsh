# antigravity doctor
if [[ ! -d "$HOME/.antigravity/antigravity/bin" ]]; then
  ome_warn "antigravity not found"
  return 1
fi

ome_info "antigravity: found at ~/.antigravity"
