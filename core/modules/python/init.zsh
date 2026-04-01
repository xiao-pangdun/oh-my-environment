# uv shell completion
(( $+commands[uv] )) || return 0

eval "$(uv generate-shell-completion zsh)"
