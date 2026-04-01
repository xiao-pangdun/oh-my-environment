# maestro doctor
if [[ ! -d "$HOME/.maestro/bin" ]]; then
  ome_warn "maestro not found"
  ome_info "  fix: curl -Ls 'https://get.maestro.mobile.dev' | bash"
  return 1
fi

ome_info "maestro: found at ~/.maestro"
