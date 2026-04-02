# Maestro PATH setup
local _d="$HOME/.maestro/bin"
[[ -d "$_d" ]] || return 0
case ":$PATH:" in *:"$_d":*) ;; *) PATH="$_d:$PATH" ;; esac
unset _d
