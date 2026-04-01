# oh-my-environment — Entry point
# Source this file from your .zshrc

export OME_HOME="${OME_HOME:-${0:h}}"

# Detect or use configured loader
if [[ "$OME_LOADER" == "auto" || -z "$OME_LOADER" ]]; then
  if (( ${+functions[zinit]} )) || [[ -f "${HOME}/.zinit/zinit.zsh" ]] || [[ -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    OME_LOADER="zinit"
  elif [[ -n "$ZSH" && -d "$ZSH" ]]; then
    OME_LOADER="oh-my-zsh"
  else
    OME_LOADER="plain"
  fi
fi
export OME_LOADER

# Source loader
local loader_file="$OME_HOME/loaders/$OME_LOADER/loader.zsh"
if [[ -f "$loader_file" ]]; then
  source "$loader_file"
else
  echo "[ome] unknown loader: $OME_LOADER" >&2
fi

# Auto-update check
source "$OME_HOME/scripts/update-check.zsh"

# Add bin/ to PATH for `ome` command
case ":$PATH:" in
  *:"$OME_HOME/bin":*) ;;
  *) export PATH="$OME_HOME/bin:$PATH" ;;
esac
