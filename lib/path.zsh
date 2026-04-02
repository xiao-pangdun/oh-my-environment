# path.zsh — Symlink helper for oh-my-environment CLI

# Create a symlink with backup.
# Usage: ome_symlink <source> <target>
ome_symlink() {
  local src="$1" target="$2"

  if [[ ! -e "$src" ]]; then
    ome_warn "symlink source does not exist: $src"
    return 1
  fi

  # Already correct
  if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
    return 0
  fi

  # Backup existing file/symlink
  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.ome-backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    ome_info "backed up: $target → $backup"
  fi

  # Ensure parent directory exists
  mkdir -p "${target:h}"

  ln -sf "$src" "$target"
}
