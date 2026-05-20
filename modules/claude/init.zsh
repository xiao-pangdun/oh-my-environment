# claude module
(( $+commands[claude] )) || return 0

_claude_module_dir="${0:A:h}"
source "$_claude_module_dir/_claude_proxy.zsh"
source "$_claude_module_dir/_plaude.zsh"
unset _claude_module_dir

claude-yolo() {
  claude --dangerously-skip-permissions "$@"
}
