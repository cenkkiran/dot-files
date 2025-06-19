#!/bin/bash

# Python Installation Script

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[PYTHON]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PYTHON]${NC} $1"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Setting up Python environment..."

# Install pyenv if not already installed
if ! command -v pyenv &> /dev/null; then
    print_status "Installing pyenv..."
    brew install pyenv
fi

# Set up pyenv in shell
if ! grep -q 'pyenv init' ~/.zshrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi

# Source the changes
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Install latest Python
print_status "Installing Python 3.12..."
pyenv install 3.12.0 2>/dev/null || print_status "Python 3.12.0 already installed"
pyenv global 3.12.0

# Upgrade pip and install essential packages
print_status "Upgrading pip..."
pip install --upgrade pip

# Install from requirements.txt if it exists
if [ -f "$DOTFILES_DIR/requirements.txt" ]; then
    print_status "Installing Python packages from requirements.txt..."
    pip install -r "$DOTFILES_DIR/requirements.txt"
else
    print_status "Installing essential Python packages..."
    pip install virtualenv pipenv poetry jupyter numpy pandas matplotlib seaborn requests flask django fastapi black pylint flake8 mypy pytest
fi

# Install Anaconda if needed (based on your current setup)
if [ ! -d "/Applications/Anaconda-Navigator.app" ]; then
    print_status "Consider installing Anaconda manually from https://www.anaconda.com/download"
fi

print_success "Python environment setup completed!"
