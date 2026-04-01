# claude module — aliases
(( $+commands[claude] )) || return 0

claude-yolo() {
  claude --dangerously-skip-permissions "$@"
}
