# _plaude.zsh — proxy-aware claude launcher
source "${0:A:h}/_claude_proxy_helpers.zsh"

plaude() {
  local proxy_url proxy_name select_proxy=0

  # Parse --select-proxy flag (consume it, don't pass to claude)
  local -a claude_args=()
  for arg in "$@"; do
    if [[ "$arg" == "--select-proxy" ]]; then
      select_proxy=1
    else
      claude_args+=("$arg")
    fi
  done

  # 1. Environment variable override
  if [[ -n "$CLAUDE_HTTPS_PROXY" ]] && (( ! select_proxy )); then
    proxy_url="$CLAUDE_HTTPS_PROXY"
    print "Using CLAUDE_HTTPS_PROXY (\e[32m$proxy_url\e[0m) \e[32m\u2714\e[0m"

  else
    # 2. Look up device binding (unless --select-proxy)
    if (( ! select_proxy )); then
      proxy_name="$(_claude_bound_proxy)"
    fi

    # 3. No binding or --select-proxy — interactive selection
    if [[ -z "$proxy_name" ]]; then
      proxy_name="$(_claude_select_proxy)" || return 1
      _claude_set_binding "$proxy_name"
      print "\e[2mBinding saved: $HOST → $proxy_name\e[0m"
    elif (( select_proxy )); then
      proxy_name="$(_claude_select_proxy)" || return 1
      _claude_set_binding "$proxy_name"
      print "\e[2mBinding updated: $HOST → $proxy_name\e[0m"
    fi

    proxy_url="$(_claude_proxy_url "$proxy_name")"
    if [[ -z "$proxy_url" ]]; then
      print "\e[31mProxy $proxy_name not found \u2718\e[0m" >&2
      return 1
    fi
    print "Using proxy $proxy_name (\e[32m$proxy_url\e[0m) \e[32m\u2714\e[0m"
  fi

  # 4. Connectivity check
  _claude_check_connectivity "$proxy_url" || return 1

  # 5. Launch claude with proxy scoped to process only
  local -a no_proxy=(localhost 127.0.0.1 ::1 .local)
  https_proxy="$proxy_url" \
  http_proxy="$proxy_url" \
  no_proxy="${(j:,:)no_proxy}" \
  claude "${claude_args[@]}"
}
