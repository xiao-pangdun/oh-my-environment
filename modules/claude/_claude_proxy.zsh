# _claude_proxy.zsh — claude-proxy config manager
source "${0:A:h}/_claude_proxy_helpers.zsh"

claude-proxy() {
  local cmd="$1"
  shift 2>/dev/null

  case "$cmd" in
    list)
      local proxies
      proxies="$(_claude_proxy_list)"
      if [[ -z "$proxies" ]]; then
        print "No proxies configured."
        return
      fi
      local bound
      bound="$(_claude_bound_proxy)"
      while IFS=' ' read -r name url; do
        if [[ "$name" == "$bound" ]]; then
          print "\e[32m* $name\e[0m  $url"
        else
          print "  $name  $url"
        fi
      done <<< "$proxies"
      ;;

    add)
      local name="$1" url="$2"
      if [[ -z "$name" || -z "$url" ]]; then
        print "Usage: claude-proxy add <name> <url>" >&2
        return 1
      fi
      if [[ -n "$(_claude_proxy_url "$name")" ]]; then
        print "\e[31m\u2718\e[0m  Proxy '$name' already exists. Remove it first." >&2
        return 1
      fi
      print "$name=$url" >> "$_claude_proxies_file"
      print "\e[32m\u2714\e[0m  Added proxy: $name  $url"
      ;;

    remove)
      local name="$1"
      if [[ -z "$name" ]]; then
        print "Usage: claude-proxy remove <name>" >&2
        return 1
      fi
      sed -i '' "/^$name=/d" "$_claude_proxies_file"
      sed -i '' "/=$name$/d" "$_claude_device_proxy_file"
      print "\e[32m\u2714\e[0m  Removed proxy: $name"
      ;;

    bind)
      local proxy_name="$1"
      if [[ -z "$proxy_name" ]]; then
        proxy_name="$(_claude_select_proxy)" || return 1
      fi
      if [[ -z "$(_claude_proxy_url "$proxy_name")" ]]; then
        print "\e[31m\u2718\e[0m  Proxy '$proxy_name' not found." >&2
        return 1
      fi
      _claude_set_binding "$proxy_name"
      print "\e[32m\u2714\e[0m  Bound $HOST → $proxy_name"
      ;;

    unbind)
      _claude_remove_binding
      print "\e[32m\u2714\e[0m  Unbound $HOST"
      ;;

    status)
      local bound
      bound="$(_claude_bound_proxy)"
      if [[ -z "$bound" ]]; then
        print "  $HOST  \e[2m(no binding)\e[0m"
      else
        local url
        url="$(_claude_proxy_url "$bound")"
        print "  $HOST → \e[32m$bound\e[0m  $url"
      fi
      ;;

    *)
      print "Usage: claude-proxy <command> [args]"
      print ""
      print "Commands:"
      print "  list               List all proxies (* = bound to current device)"
      print "  add <name> <url>   Add a proxy"
      print "  remove <name>      Remove a proxy and its device bindings"
      print "  bind [name]        Bind current device to a proxy (interactive if no name)"
      print "  unbind             Remove current device binding"
      print "  status             Show current device binding"
      ;;
  esac
}
