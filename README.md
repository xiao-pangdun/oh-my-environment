# oh-my-environment

A modular zsh environment manager built on [oh-my-zsh](https://ohmyz.sh). Self-contained modules, personal config repo sync across devices, and plugin management.

## Prerequisites

- `git`
- `zsh`
- [oh-my-zsh](https://ohmyz.sh)

## Install

If you have a personal config repo (dotfiles), have the git URL ready — the installer will ask for it.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiao-pangdun/oh-my-environment/main/install.sh)"
```

The installer will:

1. Clone ome to `~/.oh-my-environment`
2. Ask if you have a config repo — if yes, clone and link configs + plugins
3. Create `.custom/` as your `$ZSH_CUSTOM`, symlink modules, copy default `.zshrc` and `.omerc` if missing

Restart your shell or run `source ~/.zshrc` to activate.

## CLI

ome ships two commands:

### `ome` — tool management

```
ome install    Symlink modules into $ZSH_CUSTOM and run module setup
ome update     Pull latest ome and update all installed plugins
```

### `omc` — config management

```
omc init <url>            Clone config repo, link configs, install plugins
omc sync                  Pull, reconcile, commit and push
omc plugin add <org/repo> Add a GitHub plugin to .zshrc and plugins.list
omc plugin remove <name>  Remove a plugin entirely
omc plugin list           List 3rd party plugins
```

## How it works

ome manages `$ZSH_CUSTOM` via a `.custom/` directory. Each module's `init.zsh` is symlinked into `.custom/` so omz auto-sources it. Modules are self-contained — each has its own guard check and doesn't depend on ome at runtime.

```
~/.oh-my-environment/
  bin/ome              # tool CLI
  bin/omc              # config CLI
  modules/             # self-contained modules (see modules/README.md)
  .custom/             # $ZSH_CUSTOM (git-ignored, managed by ome)
  .config/             # your config repo clone (git-ignored, managed by omc)
```

## Config repo

Your personal config repo stores dotfiles organized by module name:

```
my-dotfiles/
  oh-my-zsh/.zshrc
  oh-my-zsh/plugins.list
  starship/starship.toml
  ghostty/config
  yazi/yazi.toml
```

`omc sync` keeps it in sync across devices — pulls remote changes, reconciles plugins, links configs, commits and pushes local changes.

## Configuration

ome is configured via `~/.omerc` (copied on first install, not symlinked):

```zsh
# Auto-update mode: auto | reminder | disabled
zstyle ':ome:update' mode auto

# Update frequency in days
zstyle ':ome:update' frequency 13

# Disabled modules (skip during ome install)
# zstyle ':ome:modules' disabled python starship
```
