# fnm initialization
(( $+commands[fnm] )) || { ome_error "fnm not found — node version management unavailable"; return 0; }

eval "$(fnm env --use-on-cd --shell zsh)"
