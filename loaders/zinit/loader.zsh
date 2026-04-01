# zinit loader — Loads core libs + modules, then uses zinit for plugins

source "$OME_HOME/core/libs/init.zsh"
source "$OME_HOME/core/modules/init.zsh"

# omz built-in plugins (deferred)
zinit ice wait lucid
zinit snippet OMZP::command-not-found

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

# Deferred module loading (runs after plugins/compinit)
for mod_defer in "$OME_HOME"/core/modules/*/defer.zsh(N); do
  source "$mod_defer"
done
