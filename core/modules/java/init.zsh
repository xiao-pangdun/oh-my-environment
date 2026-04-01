# SDKMAN! initialization
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] || { ome_warn "sdkman not found"; return 0; }

export SDKMAN_DIR="$HOME/.sdkman"
export SDKMAN_AUTO_ENV=true
source "$SDKMAN_DIR/bin/sdkman-init.sh"
