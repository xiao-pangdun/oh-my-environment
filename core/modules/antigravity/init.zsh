# Antigravity PATH setup
[[ -d "$HOME/.antigravity/antigravity/bin" ]] || { ome_warn "antigravity not found"; return 0; }

ome_path_prepend "$HOME/.antigravity/antigravity/bin"
