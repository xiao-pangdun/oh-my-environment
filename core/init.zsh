# core/init.zsh — Core loader for oh-my-environment
# Sources libs/ first, then modules/*/init.zsh alphabetically

local ome_core="${0:h}"

# Load shared libraries
for lib in "$ome_core"/libs/*.zsh(N); do
  source "$lib"
done

# Load modules (alphabetically), respecting OME_DISABLED_MODULES
for mod_init in "$ome_core"/modules/*/init.zsh(N); do
  local mod_name="${mod_init:h:t}"
  if (( ${OME_DISABLED_MODULES[(Ie)$mod_name]} )); then
    continue
  fi
  source "$mod_init"
done
