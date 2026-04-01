# brew module — mirror switcher

typeset -gA _ome_brew_mirrors
_ome_brew_mirrors=(
  ustc       "https://mirrors.ustc.edu.cn"
  tuna       "https://mirrors.tuna.tsinghua.edu.cn"
  aliyun     "https://mirrors.aliyun.com"
  sjtu       "https://mirror.sjtu.edu.cn"
)

typeset -gA _ome_brew_mirror_labels
_ome_brew_mirror_labels=(
  ustc       "USTC (中科大)"
  tuna       "TUNA (清华大学)"
  aliyun     "Aliyun (阿里云)"
  sjtu       "SJTU (上海交大)"
)

typeset -gA _ome_brew_bottle_paths
_ome_brew_bottle_paths=(
  ustc       "/homebrew-bottles"
  tuna       "/homebrew-bottles"
  aliyun     "/homebrew/homebrew-bottles"
  sjtu       "/homebrew-bottles"
)

typeset -gA _ome_brew_git_paths
_ome_brew_git_paths=(
  ustc       "/brew.git"
  tuna       "/git/homebrew/brew.git"
  aliyun     "/homebrew/brew.git"
  sjtu       "/git/brew.git"
)

typeset -gA _ome_brew_core_paths
_ome_brew_core_paths=(
  ustc       "/homebrew-core.git"
  tuna       "/git/homebrew/homebrew-core.git"
  aliyun     "/homebrew/homebrew-core.git"
  sjtu       "/git/homebrew-core.git"
)

brew-mirror() {
  case "${1:-}" in
    ""|status)
      if [[ -n "${HOMEBREW_BOTTLE_DOMAIN:-}" ]]; then
        echo "Current mirror:"
        echo "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
        echo "  HOMEBREW_BREW_GIT_REMOTE=${HOMEBREW_BREW_GIT_REMOTE:-<default>}"
        echo "  HOMEBREW_CORE_GIT_REMOTE=${HOMEBREW_CORE_GIT_REMOTE:-<default>}"
        echo "  HOMEBREW_API_DOMAIN=${HOMEBREW_API_DOMAIN:-<default>}"
      else
        echo "Using default Homebrew sources."
      fi
      ;;
    list)
      echo "Available mirrors:"
      echo ""
      for name in ${(ko)_ome_brew_mirror_labels}; do
        printf "  %-10s %s\n" "$name" "${_ome_brew_mirror_labels[$name]}"
      done
      ;;
    reset)
      unset HOMEBREW_BOTTLE_DOMAIN
      unset HOMEBREW_BREW_GIT_REMOTE
      unset HOMEBREW_CORE_GIT_REMOTE
      unset HOMEBREW_API_DOMAIN
      echo "Reset to default Homebrew sources."
      ;;
    *)
      local name="$1"
      local base="${_ome_brew_mirrors[$name]:-}"

      if [[ -z "$base" ]]; then
        echo "Unknown mirror: $name" >&2
        echo "Run 'brew-mirror list' to see available mirrors." >&2
        return 1
      fi

      export HOMEBREW_BOTTLE_DOMAIN="${base}${_ome_brew_bottle_paths[$name]}"
      export HOMEBREW_BREW_GIT_REMOTE="${base}${_ome_brew_git_paths[$name]}"
      export HOMEBREW_CORE_GIT_REMOTE="${base}${_ome_brew_core_paths[$name]}"
      export HOMEBREW_API_DOMAIN="${base}${_ome_brew_bottle_paths[$name]}/api"

      echo "Switched to mirror: $name"
      echo "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
      echo "  HOMEBREW_BREW_GIT_REMOTE=$HOMEBREW_BREW_GIT_REMOTE"
      echo "  HOMEBREW_CORE_GIT_REMOTE=$HOMEBREW_CORE_GIT_REMOTE"
      echo "  HOMEBREW_API_DOMAIN=$HOMEBREW_API_DOMAIN"
      ;;
  esac
}
