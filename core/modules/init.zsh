# core/modules/init.zsh — Load modules alphabetically

local ome_modules="${0:h}"

for mod_init in "$ome_modules"/*/init.zsh(N); do
  source "$mod_init"
done
