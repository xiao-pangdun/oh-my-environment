# Maestro PATH setup
[[ -d "$HOME/.maestro/bin" ]] || return 0

ome_path_prepend "$HOME/.maestro/bin"
