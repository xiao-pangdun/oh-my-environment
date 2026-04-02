# Antigravity PATH setup
local _d="$HOME/.antigravity/antigravity/bin"
[[ -d "$_d" ]] || return 0
case ":$PATH:" in *:"$_d":*) ;; *) PATH="$_d:$PATH" ;; esac
unset _d
