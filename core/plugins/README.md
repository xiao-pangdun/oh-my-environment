# Plugins

Each `.conf` file declares a third-party zsh plugin for adaptors to load.

## Format

```conf
# Human-readable comment
repo = owner/repo-name
description = What this plugin does
load = deferred
```

### Keys

| Key           | Required | Values                    | Description                          |
|---------------|----------|---------------------------|--------------------------------------|
| `repo`        | yes      | `owner/repo`              | GitHub repository                    |
| `description` | no       | free text                 | Human-readable description           |
| `load`        | no       | `immediate` or `deferred` | Loading strategy (default: immediate)|

### How adaptors interpret `load`

- **zinit**: `deferred` → turbo mode (`wait lucid`), `immediate` → direct load
- **oh-my-zsh**: all plugins loaded immediately (oh-my-zsh has no deferred loading)
- **plain**: all plugins loaded immediately via manual source

## Adding a new plugin

1. Create `plugin-name.conf` in this directory
2. Set `repo` to the GitHub `owner/repo`
3. Set `load` to `deferred` unless the plugin must be available immediately
4. Commit and run `ome update` to pick it up
