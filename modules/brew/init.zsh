# brew module — mirror switcher
(( $+commands[brew] )) || return 0

brew-mirror() {
  local -A labels bottle_domains api_domains git_remotes core_remotes

  labels=(
    ustc       "USTC (中科大)"
    tuna       "TUNA (清华大学)"
    aliyun     "Aliyun (阿里云)"
    sjtu       "SJTU (上海交大)"
  )

  bottle_domains=(
    ustc       "https://mirrors.ustc.edu.cn/homebrew-bottles"
    tuna       "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    aliyun     "https://mirrors.aliyun.com/homebrew/homebrew-bottles"
    sjtu       "https://mirror.sjtu.edu.cn/homebrew-bottles"
  )

  api_domains=(
    ustc       "https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    tuna       "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
    aliyun     "https://mirrors.aliyun.com/homebrew-bottles/api"
    sjtu       "https://mirror.sjtu.edu.cn/homebrew-bottles/api"
  )

  git_remotes=(
    ustc       "https://mirrors.ustc.edu.cn/brew.git"
    tuna       "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    aliyun     "https://mirrors.aliyun.com/homebrew/brew.git"
    sjtu       "https://mirror.sjtu.edu.cn/git/brew.git"
  )

  core_remotes=(
    ustc       "https://mirrors.ustc.edu.cn/homebrew-core.git"
    tuna       "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    aliyun     "https://mirrors.aliyun.com/homebrew/homebrew-core.git"
    sjtu       "https://mirror.sjtu.edu.cn/git/homebrew-core.git"
  )

  case "${1:-}" in
    ""|status)
      if [[ -n "${HOMEBREW_BOTTLE_DOMAIN:-}" ]]; then
        echo "Current mirror:"
        echo "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
        echo "  HOMEBREW_API_DOMAIN=${HOMEBREW_API_DOMAIN:-<default>}"
        echo "  HOMEBREW_BREW_GIT_REMOTE=${HOMEBREW_BREW_GIT_REMOTE:-<default>}"
        echo "  HOMEBREW_CORE_GIT_REMOTE=${HOMEBREW_CORE_GIT_REMOTE:-<default>}"
      else
        echo "Using default Homebrew sources."
      fi
      ;;
    list)
      echo "Available mirrors:"
      echo ""
      for name in ${(ko)labels}; do
        printf "  %-10s %s\n" "$name" "${labels[$name]}"
      done
      ;;
    reset)
      unset HOMEBREW_BOTTLE_DOMAIN
      unset HOMEBREW_API_DOMAIN
      unset HOMEBREW_BREW_GIT_REMOTE
      unset HOMEBREW_CORE_GIT_REMOTE
      echo "Reset to default Homebrew sources."
      ;;
    *)
      local name="$1"

      if [[ -z "${bottle_domains[$name]:-}" ]]; then
        echo "Unknown mirror: $name" >&2
        echo "Run 'brew-mirror list' to see available mirrors." >&2
        return 1
      fi

      export HOMEBREW_BOTTLE_DOMAIN="${bottle_domains[$name]}"
      export HOMEBREW_API_DOMAIN="${api_domains[$name]}"
      export HOMEBREW_BREW_GIT_REMOTE="${git_remotes[$name]}"
      export HOMEBREW_CORE_GIT_REMOTE="${core_remotes[$name]}"

      echo "Switched to mirror: $name"
      echo "  HOMEBREW_BOTTLE_DOMAIN=$HOMEBREW_BOTTLE_DOMAIN"
      echo "  HOMEBREW_API_DOMAIN=$HOMEBREW_API_DOMAIN"
      echo "  HOMEBREW_BREW_GIT_REMOTE=$HOMEBREW_BREW_GIT_REMOTE"
      echo "  HOMEBREW_CORE_GIT_REMOTE=$HOMEBREW_CORE_GIT_REMOTE"
      ;;
  esac
}
