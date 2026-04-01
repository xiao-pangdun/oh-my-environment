# uv shell completion
if (( $+commands[uv] )); then
  eval "$(uv generate-shell-completion zsh)"
fi
