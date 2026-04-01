# brew module — command entry point

typeset -A _ome_brew_mirrors
_ome_brew_mirrors=(
  ustc       "https://mirrors.ustc.edu.cn"
  tuna       "https://mirrors.tuna.tsinghua.edu.cn"
  aliyun     "https://mirrors.aliyun.com"
  sjtu       "https://mirror.sjtu.edu.cn"
)

typeset -A _ome_brew_mirror_labels
_ome_brew_mirror_labels=(
  ustc       "USTC (中科大)"
  tuna       "TUNA (清华大学)"
  aliyun     "Aliyun (阿里云)"
  sjtu       "SJTU (上海交大)"
)

typeset -A _ome_brew_bottle_paths
_ome_brew_bottle_paths=(
  ustc       "/homebrew-bottles"
  tuna       "/homebrew-bottles"
  aliyun     "/homebrew/homebrew-bottles"
  sjtu       "/homebrew-bottles"
)

typeset -A _ome_brew_git_paths
_ome_brew_git_paths=(
  ustc       "/brew.git"
  tuna       "/git/homebrew/brew.git"
  aliyun     "/homebrew/brew.git"
  sjtu       "/git/brew.git"
)

typeset -A _ome_brew_core_paths
_ome_brew_core_paths=(
  ustc       "/homebrew-core.git"
  tuna       "/git/homebrew/homebrew-core.git"
  aliyun     "/homebrew/homebrew-core.git"
  sjtu       "/git/homebrew-core.git"
)

_ome_brew_mirror_set() {
  local name="$1"
  local base="${_ome_brew_mirrors[$name]:-}"

  if [[ -z "$base" ]]; then
    ome_error "Unknown mirror: $name"
    ome_info "Run 'ome brew mirror list' to see available mirrors."
    return 1
  fi

  export HOMEBREW_BOTTLE_DOMAIN="${base}${_ome_brew_bottle_paths[$name]}"
  export HOMEBREW_BREW_GIT_REMOTE="${base}${_ome_brew_git_paths[$name]}"
  export HOMEBREW_CORE_GIT_REMOTE="${base}${_ome_brew_core_paths[$name]}"
  export HOMEBREW_API_DOMAIN="${base}${_ome_brew_bottle_paths[$name]}/api"

  ome_info "Switched to mirror: $name"
  ome_info "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
  ome_info "  HOMEBREW_BREW_GIT_REMOTE=$HOMEBREW_BREW_GIT_REMOTE"
  ome_info "  HOMEBREW_CORE_GIT_REMOTE=$HOMEBREW_CORE_GIT_REMOTE"
  ome_info "  HOMEBREW_API_DOMAIN=$HOMEBREW_API_DOMAIN"
}

_ome_brew_mirror_reset() {
  unset HOMEBREW_BOTTLE_DOMAIN
  unset HOMEBREW_BREW_GIT_REMOTE
  unset HOMEBREW_CORE_GIT_REMOTE
  unset HOMEBREW_API_DOMAIN
  ome_info "Reset to default Homebrew sources."
}

_ome_brew_mirror_status() {
  if [[ -n "${HOMEBREW_BOTTLE_DOMAIN:-}" ]]; then
    ome_info "Current mirror:"
    ome_info "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
    ome_info "  HOMEBREW_BREW_GIT_REMOTE=${HOMEBREW_BREW_GIT_REMOTE:-<default>}"
    ome_info "  HOMEBREW_CORE_GIT_REMOTE=${HOMEBREW_CORE_GIT_REMOTE:-<default>}"
    ome_info "  HOMEBREW_API_DOMAIN=${HOMEBREW_API_DOMAIN:-<default>}"
  else
    ome_info "Using default Homebrew sources."
  fi
}

# --- Dispatch ---

case "${1:-}" in
  mirror)
    case "${2:-}" in
      ""|status) _ome_brew_mirror_status ;;
      list)
        echo "Available mirrors:"
        echo ""
        for name in ${(ko)_ome_brew_mirror_labels}; do
          printf "  %-10s %s\n" "$name" "${_ome_brew_mirror_labels[$name]}"
        done
        ;;
      reset)     _ome_brew_mirror_reset ;;
      *)         _ome_brew_mirror_set "$2" ;;
    esac
    ;;
  *)
    echo "Usage: ome brew <command>"
    echo ""
    echo "Commands:"
    echo "  mirror [status]       Show current mirror"
    echo "  mirror list           List available mirrors"
    echo "  mirror <name>         Switch to a mirror"
    echo "  mirror reset          Reset to default Homebrew sources"
    ;;
esac
