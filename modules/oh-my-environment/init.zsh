# oh-my-environment — core module
# Sets up OME_HOME, PATH, auto-update check, and config detection

export OME_HOME="${OME_HOME:-$HOME/.oh-my-environment}"

# Add ome CLI to PATH
case ":$PATH:" in
  *:"$OME_HOME/bin":*) ;;
  *) PATH="$OME_HOME/bin:$PATH" ;;
esac

# Add completions to fpath
fpath=("$OME_HOME/completions" $fpath)

# Source user's .omerc if it exists
[[ -f "$HOME/.omerc" ]] && source "$HOME/.omerc"

# --- Auto-update check ---
() {
  local mode frequency
  zstyle -s ':ome:update' mode mode || mode="auto"
  zstyle -s ':ome:update' frequency frequency || frequency=13

  [[ "$mode" == "disabled" ]] && return

  local check_file="$OME_HOME/.last-update-check"
  local now=$(date +%s)

  # First run — create timestamp and skip
  if [[ ! -f "$check_file" ]]; then
    echo "$now" > "$check_file"
    return
  fi

  local last_check=$(<"$check_file")
  local elapsed=$(( (now - last_check) / 86400 ))

  (( elapsed < frequency )) && return

  echo "$now" > "$check_file"

  if [[ "$mode" == "auto" ]]; then
    printf '\033[0;34m[ome]\033[0m Checking for updates...\n'
    ome update
  else
    printf '\033[0;34m[ome]\033[0m Updates may be available. Run `ome update` to update.\n'
  fi
}

# --- Config detection ---
() {
  [[ -d "$OME_HOME/.config" ]] || return

  local config_repo="$OME_HOME/.config"
  local moved=0

  local links_file mod_name target source basename
  for links_file in "$OME_HOME"/modules/*/links.conf(N); do
    mod_name="${links_file:h:t}"

    # Guard check: skip if module's tool isn't available
    # (modules without init.zsh are config-only, always process)
    if [[ -f "${links_file:h}/init.zsh" ]]; then
      case "$mod_name" in
        oh-my-environment|oh-my-zsh) ;; # always process
        android)    [[ -d "$HOME/Library/Android/sdk" ]] || continue ;;
        antigravity) [[ -d "$HOME/.antigravity/antigravity/bin" ]] || continue ;;
        brew)       (( $+commands[brew] )) || continue ;;
        claude)     (( $+commands[claude] )) || continue ;;
        fzf)        (( $+commands[fzf] )) || continue ;;
        java)       [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] || continue ;;
        maestro)    [[ -d "$HOME/.maestro/bin" ]] || continue ;;
        node.js)    (( $+commands[fnm] )) || continue ;;
        python)     (( $+commands[uv] )) || continue ;;
        starship)   (( $+commands[starship] )) || continue ;;
        yazi)       (( $+commands[yazi] )) || continue ;;
        ghostty)    (( $+commands[ghostty] )) || continue ;;
      esac
    fi

    while IFS= read -r target; do
      # Skip comments and empty lines
      [[ "$target" =~ ^[[:space:]]*(#|$) ]] && continue
      # Trim whitespace
      target="${target## }"; target="${target%% }"

      # Expand ~
      target="${target/#\~/$HOME}"

      # Derive source path: <module-name>/<basename>
      basename="${target:t}"
      source="$config_repo/$mod_name/$basename"

      # If target is a regular file (not symlink to config repo), move it
      if [[ -f "$target" && ! -L "$target" ]]; then
        mkdir -p "$config_repo/$mod_name"
        mv "$target" "$source"
        ln -sf "$source" "$target"
        (( ++moved ))
        printf '\033[0;34m[ome]\033[0m Moved to config repo: %s\n' "$target"
      fi
    done < "$links_file"
  done

  # Daily sync prompt
  if [[ -d "$config_repo/.git" ]]; then
    local changes
    changes=$(git -C "$config_repo" status --porcelain 2>/dev/null)
    if [[ -n "$changes" ]]; then
      local sync_file="$OME_HOME/.last-sync-prompt"
      local now=$(date +%s)
      local should_prompt=0

      if [[ ! -f "$sync_file" ]]; then
        should_prompt=1
      else
        local last_prompt=$(<"$sync_file")
        local elapsed=$(( (now - last_prompt) / 86400 ))
        (( elapsed >= 1 )) && should_prompt=1
      fi

      if (( should_prompt )); then
        echo "$now" > "$sync_file"
        printf '\033[0;33m[ome]\033[0m Unsynced config changes. Run `omc sync` to commit and push.\n'
      fi
    fi
  fi
}
