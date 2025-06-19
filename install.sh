#!/bin/bash

# MacBook Pro Dotfiles Installation Script
# Author: Generated for cenkkiran
# Usage: ./install.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_status "Starting dotfiles installation..."
print_status "Dotfiles directory: $DOTFILES_DIR"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Phase 1: Core System Setup
print_status "Phase 1: Core System Setup"

# Install Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    print_status "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode Command Line Tools installation and re-run this script"
    exit 1
else
    print_success "Xcode Command Line Tools already installed"
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

# Phase 2: Install packages
print_status "Phase 2: Installing packages..."

# Run Homebrew installation
if [ -f "$DOTFILES_DIR/scripts/homebrew.sh" ]; then
    print_status "Running Homebrew installation script..."
    bash "$DOTFILES_DIR/scripts/homebrew.sh"
else
    print_warning "Homebrew script not found, installing from Brewfile..."
    if [ -f "$DOTFILES_DIR/Brewfile" ]; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi
fi

# Install Python packages
if [ -f "$DOTFILES_DIR/scripts/python.sh" ]; then
    print_status "Running Python installation script..."
    bash "$DOTFILES_DIR/scripts/python.sh"
fi

# Install Node.js packages
if [ -f "$DOTFILES_DIR/scripts/node.sh" ]; then
    print_status "Running Node.js installation script..."
    bash "$DOTFILES_DIR/scripts/node.sh"
fi

# Install Mac App Store apps
if [ -f "$DOTFILES_DIR/scripts/mas.sh" ]; then
    print_status "Running Mac App Store installation script..."
    bash "$DOTFILES_DIR/scripts/mas.sh"
fi

# Phase 3: Configuration
print_status "Phase 3: Setting up configurations..."

# Create symlinks
if [ -f "$DOTFILES_DIR/scripts/symlinks.sh" ]; then
    print_status "Creating symlinks..."
    bash "$DOTFILES_DIR/scripts/symlinks.sh"
fi

# Set macOS defaults
if [ -f "$DOTFILES_DIR/scripts/defaults.sh" ]; then
    print_status "Setting macOS preferences..."
    bash "$DOTFILES_DIR/scripts/defaults.sh"
fi

# Phase 4: Application Configuration
print_status "Phase 4: Configuring applications..."

# Configure VS Code
if [ -d "$DOTFILES_DIR/apps/vscode" ] && command -v code &> /dev/null; then
    print_status "Configuring VS Code..."
    if [ -f "$DOTFILES_DIR/apps/vscode/settings.json" ]; then
        cp "$DOTFILES_DIR/apps/vscode/settings.json" \
           "$HOME/Library/Application Support/Code/User/settings.json"
    fi
    if [ -f "$DOTFILES_DIR/apps/vscode/extensions.txt" ]; then
        cat "$DOTFILES_DIR/apps/vscode/extensions.txt" | xargs -n 1 code --install-extension
    fi
fi

# Configure other applications
print_status "Additional app configurations can be added here..."

print_success "Dotfiles installation completed!"
print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
print_status "Some applications may require manual login or license activation"

# Optional: Open applications that require setup
print_status "You may want to open and configure these applications manually:"
echo "  - 1Password (sign in and set up browser extension)"
echo "  - Raycast (import settings)"
echo "  - Notion (sign in)"
echo "  - Slack (sign in to workspaces)"
echo "  - Development tools (sign in, import settings)"
