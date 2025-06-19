#!/bin/bash

# Node.js Installation Script

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[NODE]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[NODE]${NC} $1"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Setting up Node.js environment..."

# Install nvm if not already installed
if [ ! -d "$HOME/.nvm" ]; then
    print_status "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Source nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    print_status "nvm already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install latest LTS Node.js
print_status "Installing Node.js LTS..."
nvm install --lts
nvm use --lts
nvm alias default node

# Install global npm packages
print_status "Installing global npm packages..."
npm install -g yarn pnpm typescript ts-node nodemon create-react-app @vue/cli @angular/cli next eslint prettier

print_success "Node.js environment setup completed!"
