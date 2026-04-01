# oh-my-environment

A modular zsh environment manager with pluggable loaders and per-module diagnostics.

## Install

Requires `git` and `zsh`.

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiao-pangdun/oh-my-environment/main/install.sh)"
```
| Argument | Default | Available values | Description |
|----------|---------|------------------|-------------|
| `--loader` | `zinit` | `zinit`, `oh-my-zsh`, `plain` | Plugin loading strategy |

Example:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/xiao-pangdun/oh-my-environment/main/install.sh)" -- --loader=oh-my-zsh
```

The installer will:
- Clone the repo to `~/.oh-my-environment`
- Bootstrap zinit and Starship automatically when using the zinit loader
- Backup your existing `~/.zshrc` (skipped if it's already a symlink)
- Symlink the loader's `.zshrc` to `~/.zshrc`

Restart your shell or run `source ~/.zshrc` to activate.

## Loaders

Loaders determine how plugins are sourced. The default is `zinit`.

| Loader | Description |
|--------|-------------|
| `zinit` | Lazy-loading with [zinit](https://github.com/zdharma-continuum/zinit) and [Starship](https://starship.rs) prompt |
| `oh-my-zsh` | Integrates with an existing [Oh My Zsh](https://ohmyz.sh) setup |
| `plain` | Sources plugins directly, no framework |

## Usage

```sh
ome install    # Symlink configs and run module installers
ome update     # Pull latest changes, update plugins, re-install configs
ome doctor     # Run diagnostics across all modules
```

## Configuration

Set these in your shell environment before sourcing ome:

| Variable | Default | Description |
|----------|---------|-------------|
| `OME_HOME` | `~/.oh-my-environment` | Install location |
| `OME_LOADER` | auto-detected | Loader to use (`zinit`, `oh-my-zsh`, `plain`) |
| `OME_AUTO_UPDATE` | `false` | `true` to update silently in the background |
| `OME_UPDATE_FREQUENCY` | `13` | Days between update checks |
| `OME_DISABLED_MODULES` | `()` | Array of module names to skip |
