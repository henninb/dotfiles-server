# Dotfiles Server

Dotfiles and configuration files for server environments, with an install script that symlinks configs into `~/.config`.

## Included Configurations

| Config | Description |
|--------|-------------|
| `config/fish/config.fish` | Fish shell configuration |
| `config/starship.toml` | Starship prompt configuration |
| `config/nvim/` | Neovim configuration |

## Installation

```bash
./install.sh
```

This script:
1. Symlinks all config files into `~/.config/`
2. On Linux, downloads and installs Neovim (latest AppImage), ripgrep, Starship, Fish, and `tree-sitter-cli`

## Prerequisites

- `curl`
- `sudo` access (for installing packages on Linux)
- `npm` (for tree-sitter-cli)
