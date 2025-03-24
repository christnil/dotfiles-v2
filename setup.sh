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

# Ghostty config
GHOSTTY_TARGET="$HOME/.config/ghostty"
GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty"

# Link the config folder if not already linked properly
if [ "$(readlink "$GHOSTTY_TARGET")" != "$GHOSTTY_SOURCE" ]; then
  rm -rf "$GHOSTTY_TARGET"
  ln -s "$GHOSTTY_SOURCE" "$GHOSTTY_TARGET"
fi

# Temp clone Catppuccin theme and copy theme files
GHOSTTY_CATTPUCCIN_TEMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/catppuccin/ghostty.git "$GHOSTTY_CATTPUCCIN_TEMP_DIR"

mkdir -p "$GHOSTTY_TARGET/themes"
cp -r "$GHOSTTY_CATTPUCCIN_TEMP_DIR/themes/"* "$GHOSTTY_TARGET/themes/"

rm -rf "$GHOSTTY_CATTPUCCIN_TEMP_DIR"

# nvim
NVIM_TARGET="$HOME/.config/nvim"
NVIM_SOURCE="$DOTFILES_DIR/nvim"

if [ "$(readlink "$NVIM_TARGET")" != "$NVIM_SOURCE" ]; then
  rm -rf "$NVIM_TARGET"
  ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
fi

# bin (only if sudo)
for file in "$DOTFILES_DIR/bin/"*; do
  sudo ln -sf "$file" /usr/local/bin/$(basename "$file")
done
