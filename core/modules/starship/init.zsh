# Starship prompt initialization
(( $+commands[starship] )) || return 0

eval "$(starship init zsh)"
