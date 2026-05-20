# _claude_proxy_helpers.zsh — internal helpers for proxy config and connectivity

_claude_config_dir="$HOME/.config/claude"
_claude_proxies_file="$_claude_config_dir/proxies.conf"
_claude_device_proxy_file="$_claude_config_dir/device-proxy.conf"

# Read proxy URL by name from proxies file
# Usage: _claude_proxy_url <name>
_claude_proxy_url() {
  local name="$1"
  local file="$_claude_proxies_file"
  [[ -f "$file" ]] || return 1
  awk -F= -v name="$name" '!/^[[:space:]]*(#|$)/ && $1 == name { print $2; exit }' "$file"
}

# Read all proxies as "name url" lines
_claude_proxy_list() {
  local file="$_claude_proxies_file"
  [[ -f "$file" ]] || return 1
  awk -F= '!/^[[:space:]]*(#|$)/ && NF >= 2 { print $1, $2 }' "$file"
}

# Read bound proxy name for current host
_claude_bound_proxy() {
  local file="$_claude_device_proxy_file"
  [[ -f "$file" ]] || return 1
  awk -F= -v host="$HOST" '!/^[[:space:]]*(#|$)/ && $1 == host { print $2; exit }' "$file"
}

# Write or update device-proxy binding for current host
_claude_set_binding() {
  local proxy_name="$1"
  local file="$_claude_device_proxy_file"
  [[ -f "$file" ]] || { print "device-proxy.conf not found: $file" >&2; return 1 }
  if grep -q "^$HOST=" "$file" 2>/dev/null; then
    sed -i '' "s|^$HOST=.*|$HOST=$proxy_name|" "$file"
  else
    print "$HOST=$proxy_name" >> "$file"
  fi
}

# Remove device-proxy binding for current host
_claude_remove_binding() {
  local file="$_claude_device_proxy_file"
  [[ -f "$file" ]] || return 1
  sed -i '' "/^$HOST=/d" "$file"
}

# Interactive proxy selector — prints chosen proxy name
_claude_select_proxy() {
  local -a names=()
  local -a urls=()
  local line name url

  while IFS= read -r line; do
    name="${line%% *}"
    url="${line#* }"
    names+=("$name")
    urls+=("$url")
  done < <(_claude_proxy_list)

  if (( ${#names} == 0 )); then
    print "No proxies configured. Use: claude-proxy add <name> <url>" >&2
    return 1
  fi

  print "Select a proxy:" >&2
  local i
  for (( i = 1; i <= ${#names}; i++ )); do
    print "  $i) ${names[$i]}  \e[2m${urls[$i]}\e[0m" >&2
  done

  local choice
  print -n "Enter number: " >&2
  read -r choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#names} )); then
    print "${names[$choice]}"
  else
    print "Invalid selection." >&2
    return 1
  fi
}

# Connectivity check with animated spinner
# Usage: _claude_check_connectivity <proxy_url>
_claude_check_connectivity() {
  local proxy_url="$1"
  local -a spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  local i=0

  setopt local_options no_monitor
  curl -s -o /dev/null --connect-timeout 2 --max-time 3 \
       -x "$proxy_url" https://api.anthropic.com 2>/dev/null &
  local curl_pid=$!
  while kill -0 $curl_pid 2>/dev/null; do
    printf "api.anthropic.com reaching %s" "${spin[$(( i % $#spin + 1 ))]}"
    (( i++ ))
    sleep 0.08
    printf "\r"
  done
  wait $curl_pid
  local curl_exit=$?
  printf "\r\033[K"
  if (( curl_exit != 0 )); then
    print "\e[31mapi.anthropic.com unreachable \u2718\e[0m"
    return 1
  fi
  print "\e[32mapi.anthropic.com reached \u2714\e[0m"
}
