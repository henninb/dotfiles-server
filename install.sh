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

if [ "$(uname)" = "Linux" ]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod u+x nvim-linux-x86_64.appimage
  sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

  sudo apt install -y ripgrep
  sudo apt install -y starship
  sudo apt install -y fish
  sudo npm install -g tree-sitter-cli
fi

echo ""
echo "Dotfiles installed."

exit 0

# vim: set ft=sh:
