# ios doctor
if ! (( $+commands[xcode-select] )); then
  ome_info "ios: Xcode CLI tools not installed"
  ome_info "  install: xcode-select --install"
  return 0
fi

ome_info "ios: Xcode CLI tools installed"

if ! (( $+commands[xcodebuild] )); then
  ome_warn "ios: Xcode not installed — full IDE and Simulator unavailable"
  ome_info "  fix: install Xcode from the Mac App Store"
  return 1
fi

# AXe requires Xcode and Simulator
if ! (( $+commands[axe] )); then
  ome_info "ios: axe not installed — simulator automation unavailable"
  ome_info "  install: brew install cameroncooke/axe/axe"
fi
