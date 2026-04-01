# Modules

Each module is a directory under `modules/` representing a tool or SDK.

## Structure

```
modules/
└── your-tool/
    ├── init.zsh       # Required — sourced at shell startup
    ├── install.zsh       # Optional — run by `ome install` to create symlinks
    └── config.toml    # Optional — config file managed by install.zsh
```

## Conventions

- **`init.zsh`** (required): Runs at every shell startup. Keep it fast. Guard with existence checks:
  ```zsh
  if (( $+commands[your-tool] )); then
    eval "$(your-tool init zsh)"
  fi
  ```
- **`install.zsh`** (optional): Only executed by `ome install`, never at startup. Use `ome_symlink` helper:
  ```zsh
  ome_symlink "${0:h}/config.toml" "$HOME/.config/your-tool/config.toml"
  ```
- Modules are loaded alphabetically by directory name
- Modules must be self-contained — no cross-module dependencies
- Use `ome_path_prepend` / `ome_path_append` from `core/libs/path.zsh` for PATH setup

## Disabling modules

Set `OME_DISABLED_MODULES` in your `.zshrc` before sourcing ome:

```zsh
OME_DISABLED_MODULES=(java maestro)
```
