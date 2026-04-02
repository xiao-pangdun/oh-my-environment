# Starship prompt initialization
# Deferred to run after .zshrc fully loads — starship must init last
# so it can wrap all existing prompt hooks.
(( $+commands[starship] )) || return 0

function _ome_starship_deferred_init() {
  eval "$(starship init zsh)"
  precmd_functions=(${precmd_functions:#_ome_starship_deferred_init})
  unfunction _ome_starship_deferred_init 2>/dev/null
}
precmd_functions+=(_ome_starship_deferred_init)
