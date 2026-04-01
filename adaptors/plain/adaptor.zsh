# plain adaptor — Loads core modules + manually clones/sources 3rd-party plugins

# Load core modules (PATH setup, SDK init, etc.)
source "$OME_HOME/core/init.zsh"

# Plugin cache directory
local plugin_dir="$OME_HOME/.plugins"
mkdir -p "$plugin_dir"

# Parse .conf files and load plugins by cloning + sourcing
local conf_file repo
for conf_file in "$OME_HOME"/core/plugins/*.conf(N); do
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
