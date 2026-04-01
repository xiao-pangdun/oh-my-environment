# Shared Libraries

Utility functions sourced before modules by `core/init.zsh`.

## Available Libraries

| File       | Purpose                                      |
|------------|----------------------------------------------|
| `log.zsh`  | `ome_info`, `ome_warn`, `ome_error` — colored logging |
| `path.zsh` | `ome_path_prepend`, `ome_path_append` — safe PATH helpers with dedup; `ome_symlink` — backup + symlink |

## Adding a new library

1. Create `your-lib.zsh` in this directory
2. All `*.zsh` files are auto-sourced alphabetically
3. Prefix all functions with `ome_` to avoid conflicts
