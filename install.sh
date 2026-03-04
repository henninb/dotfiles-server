#!/bin/sh

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"

link() {
  src="$1"
  dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "linked: $dst -> $src"
}

link "$DOTFILES/config/fish/config.fish" "$CONFIG/fish/config.fish"
link "$DOTFILES/config/starship.toml"   "$CONFIG/starship.toml"
link "$DOTFILES/config/nvim"            "$CONFIG/nvim"

echo ""
echo "Dotfiles installed."

exit 0

# vim: set ft=sh:
