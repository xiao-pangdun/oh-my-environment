# Modules

Each module is a self-contained directory. Modules are loaded by omz via `$ZSH_CUSTOM` — ome symlinks each `init.zsh` into `.custom/<name>.zsh`.

## Module structure

```
modules/<name>/
  init.zsh        # shell init (sourced every session via omz)
  links.conf      # config file mappings (optional)
  install.zsh     # first-time setup (optional)
  .foo.example    # default config template (optional)
```

All files are optional — a module needs at least one of `init.zsh` or `links.conf`.

### `init.zsh`

Sourced on every shell session. Must be **standalone** — no dependency on ome libs or other modules.

Rules:

- **Guard first.** Return early if the tool isn't installed. This keeps shell startup fast and error-free.
- **Inline helpers.** Don't source ome's `lib/` files. If you need to add to PATH, inline the logic.
- **No side effects on missing tools.** A module for `starship` should do nothing if `starship` isn't in PATH.

```zsh
# Example: modules/starship/init.zsh
(( $+commands[starship] )) || return 0
eval "$(starship init zsh)"
```

```zsh
# Example: modules/android/init.zsh (with PATH manipulation)
[[ -d "$HOME/Library/Android/sdk" ]] || return 0
export ANDROID_HOME="$HOME/Library/Android/sdk"
local _d
for _d in "$ANDROID_HOME"/{emulator,platform-tools,cmdline-tools/latest/bin}; do
  [[ -d "$_d" ]] && case ":$PATH:" in *:"$_d":*) ;; *) PATH="$PATH:$_d" ;; esac
done
unset _d
```

### `links.conf`

Declares where config files should be symlinked. One target path per line. The source path is derived by convention: `<module-name>/<basename>` in the user's config repo.

```conf
# modules/yazi/links.conf
# config repo source: yazi/yazi.toml → target:
~/.config/yazi/yazi.toml
~/.config/yazi/theme.toml
~/.config/yazi/keymap.toml
```

Only files that exist in the config repo are linked. Missing files are silently skipped.

### `install.zsh`

Runs during `ome install`. Used for first-time setup like copying `.example` files.

```zsh
# Example: modules/oh-my-zsh/install.zsh
[[ -f "$HOME/.zshrc" ]] || cp "${0:h}/.zshrc.example" "$HOME/.zshrc"
```

## Adding a new module

1. Create `modules/<name>/init.zsh` with a guard
2. If the tool has config files: create `links.conf` with target paths
3. Run `ome install` to symlink it into `.custom/`

The module will be auto-sourced by omz on next shell session.

## Disabling a module

Add the module name to `~/.omerc`:

```zsh
zstyle ':ome:modules' disabled python starship
```

Then run `ome install` to update symlinks.
