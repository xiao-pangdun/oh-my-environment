# Maestro PATH setup
[[ -d "$HOME/.maestro/bin" ]] || { ome_warn "maestro not found"; return 0; }

ome_path_prepend "$HOME/.maestro/bin"
