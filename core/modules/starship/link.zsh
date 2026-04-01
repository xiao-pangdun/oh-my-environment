# Symlink starship.toml to ~/.config/starship.toml
(( $+commands[starship] )) || return 0

ome_symlink "${0:h}/starship.toml" "$HOME/.config/starship.toml"
