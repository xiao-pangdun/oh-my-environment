# yazi initialization — shell wrapper for directory changing on exit
(( $+commands[yazi] )) || { ome_error "yazi not found — file manager unavailable"; return 0; }

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
