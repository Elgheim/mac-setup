#!/bin/bash

# Mac setup installation script
# Creates symlinks from home directory to dotfiles

set -e

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles from $DOTFILES"

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

backup_and_link() {
  local source="$1"
  local target="$2"

  # If target exists and is not a symlink, back it up
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $target to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi

  # Remove existing symlink if it exists
  if [ -L "$target" ]; then
    rm "$target"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$target")"

  # Create symlink
  ln -sf "$source" "$target"
  echo "Linked $source -> $target"
}

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
  echo ""
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Homebrew packages
if [ -f "$DOTFILES/Brewfile" ]; then
  echo ""
  echo "Installing Homebrew packages..."
  brew bundle --file="$DOTFILES/Brewfile"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ""
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Create symlinks
echo ""
echo "Creating symlinks..."

# Zsh
backup_and_link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

# Ghostty
backup_and_link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# Git
backup_and_link "$DOTFILES/git/config" "$HOME/.gitconfig"
backup_and_link "$DOTFILES/git/ignore" "$HOME/.config/git/ignore"

# Cursor
backup_and_link "$DOTFILES/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"

# Install Cursor extensions
if command -v cursor &> /dev/null; then
  echo ""
  echo "Installing Cursor extensions..."
  while read -r ext; do
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue
    cursor --install-extension "$ext" 2>/dev/null || true
  done < "$DOTFILES/cursor/extensions.txt"
fi

# Create secrets template if ~/.secrets doesn't exist
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets from template..."
  cp "$DOTFILES/secrets/.secrets.example" "$HOME/.secrets"
  echo "IMPORTANT: Edit ~/.secrets to add your API keys"
fi

echo ""
echo "Done! Dotfiles installed."
echo ""
echo "Next steps:"
echo "  1. Restart terminal or run: source ~/.zshrc"
echo "  2. Edit ~/.secrets to add your API keys"
echo "  3. Run 'brewsave' to update Brewfile before migrating to new machine"
