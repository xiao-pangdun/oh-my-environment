#!/bin/sh
# install.sh — One-line installer for oh-my-environment
# Usage: bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiao-pangdun/oh-my-environment/main/install.sh)"

set -e

# Defaults
OME_HOME="${OME_HOME:-$HOME/.oh-my-environment}"
OME_REPO="https://github.com/xiao-pangdun/oh-my-environment.git"
CONFIG_REPO=""

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --config=*) CONFIG_REPO="${arg#--config=}" ;;
    --skip-config) CONFIG_REPO="__skip__" ;;
    --help)
      echo "Usage: install.sh [--config=<git-url>] [--skip-config]"
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

# Check oh-my-zsh
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
if [ ! -d "$ZSH" ]; then
  error "oh-my-zsh is required but not found at $ZSH. Install: https://ohmyz.sh"
fi

# Clone ome
if [ -d "$OME_HOME" ]; then
  info "oh-my-environment already installed at $OME_HOME"
else
  info "Cloning oh-my-environment to $OME_HOME..."
  git clone "$OME_REPO" "$OME_HOME"
fi

# Make CLIs executable
chmod +x "$OME_HOME/bin/ome"
chmod +x "$OME_HOME/bin/omc"

export OME_HOME

# Config repo setup (before ome install, so config repo files take priority)
if [ -z "$CONFIG_REPO" ]; then
  # Interactive prompt
  printf '\033[0;34m[ome]\033[0m Do you have a config repo? [y/n] '
  read -r answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    printf '\033[0;34m[ome]\033[0m Config repo URL: '
    read -r CONFIG_REPO
  fi
fi

if [ -n "$CONFIG_REPO" ] && [ "$CONFIG_REPO" != "__skip__" ]; then
  info "Setting up config repo..."
  zsh "$OME_HOME/bin/omc" init "$CONFIG_REPO"
fi

# Run ome install (create .custom/, symlink modules, copy defaults if missing)
info "Running ome install..."
zsh "$OME_HOME/bin/ome" install

info ""
info "oh-my-environment installed successfully!"
info "  Location: $OME_HOME"
info ""
info "Restart your shell or run: source ~/.zshrc"
