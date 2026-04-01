# core/modules/init.zsh — Load modules alphabetically, respecting OME_DISABLED_MODULES

local ome_modules="${0:h}"

for mod_init in "$ome_modules"/*/init.zsh(N); do
  local mod_name="${mod_init:h:t}"
  if (( ${OME_DISABLED_MODULES[(Ie)$mod_name]} )); then
    continue
  fi
  source "$mod_init"
done
