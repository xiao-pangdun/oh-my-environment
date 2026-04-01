# Starship prompt initialization
(( $+commands[starship] )) || { ome_error "starship not found — customized prompt unavailable"; return 0; }

eval "$(starship init zsh)"
