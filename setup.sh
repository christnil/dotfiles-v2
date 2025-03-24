#!/bin/bash

# Get the directory of the script (i.e., the root of your dotfiles repo)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# tmux
for file in "$DOTFILES_DIR/tmux/"*; do
  ln -sf "$file" ~/.config/tmux/$(basename "$file")
done
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf

# TPM (Tmux Plugin Manager)
TPM_DIR=~/.tmux/plugins/tpm
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed."
fi

# aerospace
AEROSPACE_TARGET="$HOME/.config/aerospace"
AEROSPACE_SOURCE="$DOTFILES_DIR/aerospace"

if [ "$(readlink "$AEROSPACE_TARGET")" != "$AEROSPACE_SOURCE" ]; then
  rm -rf "$AEROSPACE_TARGET"
  ln -s "$AEROSPACE_SOURCE" "$AEROSPACE_TARGET"
fi

# git
ln -sf "$DOTFILES_DIR/gitconfig.symlink" ~/.gitconfig

# bin (only if sudo)
for file in "$DOTFILES_DIR/bin/"*; do
  sudo ln -sf "$file" /usr/local/bin/$(basename "$file")
done
