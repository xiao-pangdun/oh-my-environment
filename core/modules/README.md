# Modules

Each module is a directory under `modules/` representing a tool or SDK.

## Structure

```
modules/
└── your-tool/
    ├── init.zsh       # Sourced at shell startup (define functions, set PATH, etc.)
    ├── defer.zsh      # Optional — sourced after plugins (for compdef, etc.)
    ├── doctor.zsh     # Optional — run by `ome doctor` for diagnostics
    ├── install.zsh    # Optional — run by `ome install` to create symlinks
    └── config.toml    # Optional — config file managed by install.zsh
```

## Conventions

- **`init.zsh`** (required): Runs at every shell startup. Keep it fast. Guard with existence checks:
  ```zsh
  if (( $+commands[your-tool] )); then
    eval "$(your-tool init zsh)"
  fi
  ```
- **`defer.zsh`** (optional): Sourced after plugins are loaded. Use for anything that requires `compdef` or other plugin-provided functions:
  ```zsh
  eval "$(your-tool generate-shell-completion zsh)"
  ```
- **`install.zsh`** (optional): Only executed by `ome install`, never at startup. Use `ome_symlink` helper:
  ```zsh
  ome_symlink "${0:h}/config.toml" "$HOME/.config/your-tool/config.toml"
  ```
- Modules are loaded alphabetically by directory name
- Modules must be self-contained — no cross-module dependencies
- Use `ome_path_prepend` / `ome_path_append` from `core/libs/path.zsh` for PATH setup
