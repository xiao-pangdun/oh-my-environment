# claude module — undo bridge symlinks created by install.zsh
local agent_links=(
  "$HOME/.agents/skills:$HOME/.claude/skills"
)
local entry expected_src target
for entry in "${agent_links[@]}"; do
  expected_src="${entry%%:*}"
  target="${entry##*:}"
  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$expected_src" ]]; then
      rm -f "$target"
      ome_info "Removed link: $target"
    else
      ome_warn "Skipping $target — points to unexpected location"
    fi
  fi
done
