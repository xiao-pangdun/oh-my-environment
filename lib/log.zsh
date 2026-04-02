# log.zsh — Colored logging helpers for oh-my-environment CLI

ome_info() {
  printf '\033[0;34m[ome]\033[0m %s\n' "$*"
}

ome_warn() {
  printf '\033[0;33m[ome]\033[0m %s\n' "$*" >&2
}

ome_error() {
  printf '\033[0;31m[ome]\033[0m %s\n' "$*" >&2
}
