# claude module — install default config files
local config_dir="$HOME/.config/claude"
local module_dir="${0:h}"

[[ -d "$config_dir" ]] || mkdir -p "$config_dir"

if [[ ! -f "$config_dir/proxies.conf" ]]; then
  cp "$module_dir/proxies.conf.example" "$config_dir/proxies.conf"
fi

if [[ ! -f "$config_dir/device-proxy.conf" ]]; then
  cp "$module_dir/device-proxy.conf.example" "$config_dir/device-proxy.conf"
fi

# Bridge ~/.agents/* into ~/.claude/* so Claude Code discovers cross-tool skills/etc.
local agent_links=(
  "$HOME/.agents/skills:$HOME/.claude/skills"
)
local entry src target
for entry in "${agent_links[@]}"; do
  src="${entry%%:*}"
  target="${entry##*:}"
  [[ -e "$src" ]] || continue
  ome_symlink "$src" "$target"
done
