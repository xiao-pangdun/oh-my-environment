# Android SDK PATH setup
[[ -d "$HOME/Library/Android/sdk" ]] || return 0

export ANDROID_HOME="$HOME/Library/Android/sdk"

local _d
for _d in "$ANDROID_HOME"/{emulator,platform-tools,cmdline-tools/latest/bin}; do
  [[ -d "$_d" ]] && case ":$PATH:" in *:"$_d":*) ;; *) PATH="$PATH:$_d" ;; esac
done
unset _d
