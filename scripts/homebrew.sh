#!/bin/bash

# Homebrew Installation Script

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[HOMEBREW]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[HOMEBREW]${NC} $1"
}

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Installing packages from Brewfile..."

# Update Homebrew
print_status "Updating Homebrew..."
brew update

# Install everything from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    print_status "Installing from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Homebrew packages installed successfully"
else
    print_status "Brewfile not found, installing essential packages manually..."
    
    # Essential CLI tools
    brew install git curl wget tree htop jq ripgrep fd bat exa fzf tmux neovim starship
    
    # Development tools
    brew install python@3.12 node docker
    
    # Essential GUI apps
    brew install --cask arc visual-studio-code cursor iterm2 raycast 1password slack
fi

# Cleanup
print_status "Cleaning up Homebrew..."
brew cleanup

print_success "Homebrew installation completed!"
