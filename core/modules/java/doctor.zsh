# sdkman doctor
if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  ome_warn "sdkman not found"
  ome_info "  fix: curl -s 'https://get.sdkman.io' | bash"
  return 1
fi

ome_info "sdkman: found at ~/.sdkman"
