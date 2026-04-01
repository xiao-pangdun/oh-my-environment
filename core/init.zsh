# core/init.zsh — Core loader for oh-my-environment
# Sources libs, modules, and plugins via their respective init.zsh

local ome_core="${0:h}"

source "$ome_core/libs/init.zsh"
source "$ome_core/modules/init.zsh"
source "$ome_core/plugins/init.zsh"
