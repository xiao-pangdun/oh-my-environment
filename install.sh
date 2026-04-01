#!/bin/sh
# install.sh — One-line installer for oh-my-environment
# Usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/xiao-pangdun/oh-my-environment/main/install.sh)"

set -e

# Defaults
OME_HOME="${OME_HOME:-$HOME/.oh-my-environment}"
OME_REPO="https://github.com/xiao-pangdun/oh-my-environment.git"
OME_LOADER="${OME_LOADER:-zinit}"
UNATTENDED=false

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --loader=*) OME_LOADER="${arg#--loader=}" ;;
    --unattended) UNATTENDED=true ;;
    --help)
      echo "Usage: install.sh [--loader=zinit|oh-my-zsh|plain] [--unattended]"
      exit 0
      ;;
  esac
done

info() { printf '\033[0;34m[ome]\033[0m %s\n' "$1"; }
warn() { printf '\033[0;33m[ome]\033[0m %s\n' "$1"; }
error() { printf '\033[0;31m[ome]\033[0m %s\n' "$1" >&2; exit 1; }

# Check prerequisites
command -v git >/dev/null 2>&1 || error "git is required but not found"
command -v zsh >/dev/null 2>&1 || error "zsh is required but not found"

# Clone ome
if [ -d "$OME_HOME" ]; then
  info "oh-my-environment already installed at $OME_HOME"
else
  info "Cloning oh-my-environment to $OME_HOME..."
  git clone "$OME_REPO" "$OME_HOME"
fi

# Bootstrap zinit if selected and not found
if [ "$OME_LOADER" = "zinit" ]; then
  if [ ! -d "$HOME/.zinit" ]; then
    info "Installing zinit..."
    mkdir -p "$HOME/.zinit"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/zinit.zsh" 2>/dev/null || \
      git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit"
    info "zinit installed."
  else
    info "zinit already installed."
  fi

  # Bootstrap Starship if not found
  if ! command -v starship >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
      info "Installing Starship via Homebrew..."
      brew install starship
    else
      warn "Starship not found and Homebrew not available."
      warn "Install Starship manually: https://starship.rs"
    fi
  else
    info "Starship already installed."
  fi
fi

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  backup="$HOME/.zshrc.ome-backup.$(date +%Y%m%d%H%M%S)"
  cp "$HOME/.zshrc" "$backup"
  info "Backed up existing .zshrc to $backup"
elif [ -L "$HOME/.zshrc" ]; then
  info "Existing .zshrc is a symlink, will be replaced."
fi

# Export for ome install
export OME_HOME OME_LOADER

# Make ome executable
chmod +x "$OME_HOME/bin/ome"

# Run ome install for initial setup
info "Running ome install..."
zsh "$OME_HOME/bin/ome" install

info ""
info "oh-my-environment installed successfully!"
info "  Loader: $OME_LOADER"
info "  Location: $OME_HOME"
info ""
info "Restart your shell or run: source ~/.zshrc"
