#!/bin/bash

# Symlinks Creation Script

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[SYMLINKS]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SYMLINKS]${NC} $1"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Creating symlinks for configuration files..."

# Create backup directory for existing configs
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to safely create symlinks
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        print_status "Backing up existing $target"
        mv "$target" "$BACKUP_DIR/"
    fi
    
    ln -s "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Create symlinks for dotfiles
create_symlink "$DOTFILES_DIR/config/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/config/.gitconfig" "$HOME/.gitconfig"

# Create starship config directory if it doesn't exist
mkdir -p "$HOME/.config"
create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

# Create SSH directory if it doesn't exist
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# If SSH config exists in dotfiles, symlink it
if [ -f "$DOTFILES_DIR/config/ssh/config" ]; then
    create_symlink "$DOTFILES_DIR/config/ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

print_success "Symlinks created successfully!"
print_status "Backup of original files saved to: $BACKUP_DIR"
