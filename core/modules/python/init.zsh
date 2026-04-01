# uv shell completion
(( $+commands[uv] )) || { ome_error "uv not found — python management unavailable"; return 0; }

eval "$(uv generate-shell-completion zsh)"
