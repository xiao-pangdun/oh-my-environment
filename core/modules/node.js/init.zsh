# fnm initialization
(( $+commands[fnm] )) || return 0

eval "$(fnm env --use-on-cd --shell zsh)"
