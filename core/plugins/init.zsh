# core/plugins/init.zsh — Default plugin loader (clone + source)
# Adaptors may override this with their own plugin loading logic

local ome_plugins="${0:h}"
local plugin_dir="$OME_HOME/.plugins"
mkdir -p "$plugin_dir"

local conf_file repo
for conf_file in "$ome_plugins"/*.conf(N); do
  repo=""

  while IFS='= ' read -r key value; do
    [[ "$key" == \#* || -z "$key" ]] && continue
    key="${key// /}" value="${value// /}"
    case "$key" in
      repo) repo="$value" ;;
    esac
  done < "$conf_file"

  [[ -z "$repo" ]] && continue

  local plugin_name="${repo##*/}"
  local plugin_path="$plugin_dir/$plugin_name"

  # Clone if not present
  if [[ ! -d "$plugin_path" ]]; then
    git clone --depth 1 "https://github.com/$repo.git" "$plugin_path" 2>/dev/null
  fi

  # Source the plugin (try common entry point patterns)
  local entry
  for entry in "$plugin_path/$plugin_name.plugin.zsh" \
               "$plugin_path/$plugin_name.zsh" \
               "$plugin_path/${plugin_name}.zsh-theme"; do
    if [[ -f "$entry" ]]; then
      source "$entry"
      break
    fi
  done
done
