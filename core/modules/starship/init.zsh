# Starship prompt initialization
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
