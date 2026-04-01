# oh-my-environment — Entry point
# Source this file from your .zshrc

export OME_HOME="${OME_HOME:-${0:h}}"

# Detect or use configured adaptor
if [[ "$OME_ADAPTOR" == "auto" || -z "$OME_ADAPTOR" ]]; then
  if (( ${+functions[zinit]} )) || [[ -f "${HOME}/.zinit/zinit.zsh" ]] || [[ -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    OME_ADAPTOR="zinit"
  elif [[ -n "$ZSH" && -d "$ZSH" ]]; then
    OME_ADAPTOR="oh-my-zsh"
  else
    OME_ADAPTOR="plain"
  fi
fi
export OME_ADAPTOR

# Source adaptor
local adaptor_file="$OME_HOME/adaptors/$OME_ADAPTOR/adaptor.zsh"
if [[ -f "$adaptor_file" ]]; then
  source "$adaptor_file"
else
  echo "[ome] unknown adaptor: $OME_ADAPTOR" >&2
fi

# Auto-update check
source "$OME_HOME/scripts/update-check.zsh"

# Add bin/ to PATH for `ome` command
case ":$PATH:" in
  *:"$OME_HOME/bin":*) ;;
  *) export PATH="$OME_HOME/bin:$PATH" ;;
esac
