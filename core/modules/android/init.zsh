# Android SDK PATH setup
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  ome_path_append "$ANDROID_HOME/emulator"
  ome_path_append "$ANDROID_HOME/platform-tools"
  ome_path_append "$ANDROID_HOME/cmdline-tools/latest/bin"
fi
