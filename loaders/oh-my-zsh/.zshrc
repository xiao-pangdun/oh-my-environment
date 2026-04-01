# .zshrc — Template for oh-my-zsh loader
# Managed by oh-my-environment. Edit OME_* variables below to customize.

# oh-my-environment configuration
# export OME_LOADER="oh-my-zsh"
# export OME_AUTO_UPDATE=false
# export OME_UPDATE_FREQUENCY=13
# export OME_DISABLED_MODULES=()

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

plugins=(
  git
  command-not-found
)

# Initialize oh-my-environment (adds 3rd-party plugins to plugins array)
source "${HOME}/.oh-my-environment/oh-my-environment.plugin.zsh"

# Initialize oh-my-zsh (must come after ome so plugins array is populated)
source "$ZSH/oh-my-zsh.sh"
