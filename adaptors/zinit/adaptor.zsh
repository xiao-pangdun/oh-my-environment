# zinit adaptor — Loads core modules + uses zinit for 3rd-party plugins

# Load core modules (PATH setup, SDK init, etc.)
source "$OME_HOME/core/init.zsh"

# Parse .conf files and load plugins via zinit
local conf_file repo load_mode
for conf_file in "$OME_HOME"/core/plugins/*.conf(N); do
  repo="" load_mode="immediate"

  while IFS='= ' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" == \#* || -z "$key" ]] && continue
    # Trim whitespace
    key="${key// /}" value="${value// /}"
    case "$key" in
      repo) repo="$value" ;;
      load) load_mode="$value" ;;
    esac
  done < "$conf_file"

  [[ -z "$repo" ]] && continue

  if [[ "$load_mode" == "deferred" ]]; then
    zinit ice wait lucid
  fi
  zinit light "$repo"
done
