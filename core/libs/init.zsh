# core/libs/init.zsh — Load shared libraries alphabetically

local ome_libs="${0:h}"

for lib in "$ome_libs"/*.zsh(N); do
  [[ "$lib" == */init.zsh ]] && continue
  source "$lib"
done
