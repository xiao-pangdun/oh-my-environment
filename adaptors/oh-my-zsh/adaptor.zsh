# oh-my-zsh adaptor — Loads core modules + declares plugins for oh-my-zsh

# Load core modules (PATH setup, SDK init, etc.)
source "$OME_HOME/core/init.zsh"

# Parse .conf files and collect plugin repo names for oh-my-zsh
# oh-my-zsh expects plugins to be cloned into $ZSH_CUSTOM/plugins/
# All plugins are loaded immediately (oh-my-zsh has no deferred loading)
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

  # Clone plugin if not present
  if [[ ! -d "${ZSH_CUSTOM:-$ZSH/custom}/plugins/$plugin_name" ]]; then
    git clone --depth 1 "https://github.com/$repo.git" \
      "${ZSH_CUSTOM:-$ZSH/custom}/plugins/$plugin_name" 2>/dev/null
  fi

  # Add to oh-my-zsh plugins array if not already present
  if (( ! ${plugins[(Ie)$plugin_name]} )); then
    plugins+=("$plugin_name")
  fi
done
