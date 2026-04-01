# update-check.zsh — Auto-update prompt at shell startup

() {
  local check_file="$OME_HOME/.last-update-check"
  local frequency="${OME_UPDATE_FREQUENCY:-13}"
  local now=$(date +%s)

  # First run — create timestamp and skip
  if [[ ! -f "$check_file" ]]; then
    echo "$now" > "$check_file"
    return
  fi

  local last_check=$(<"$check_file")
  local elapsed=$(( (now - last_check) / 86400 ))

  if (( elapsed >= frequency )); then
    echo "$now" > "$check_file"

    if [[ "$OME_AUTO_UPDATE" == "true" ]]; then
      # Silent background update
      ( ome update &>/dev/null & )
    else
      ome_info "Updates may be available. Run \`ome update\` to update."
    fi
  fi
}
