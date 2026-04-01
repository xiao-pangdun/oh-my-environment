# uv shell completion (requires compdef)
(( $+commands[uv] )) || return 0

eval "$(uv generate-shell-completion zsh)"
