# android doctor
if [[ ! -d "$HOME/Library/Android/sdk" ]]; then
  ome_warn "Android SDK not found"
  ome_info "  fix: install Android Studio or set up SDK manually"
  return 1
fi

ome_info "android: SDK found at ~/Library/Android/sdk"

if [[ ! -x "$HOME/Library/Android/sdk/platform-tools/adb" ]]; then
  ome_warn "adb not found in SDK"
  ome_info "  fix: sdkmanager --install 'platform-tools'"
fi

if [[ ! -d "$HOME/Library/Android/sdk/emulator" ]]; then
  ome_warn "emulator not found in SDK"
  ome_info "  fix: sdkmanager --install 'emulator'"
fi
