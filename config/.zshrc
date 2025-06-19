# Zsh Configuration
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME=""  # We'll use Starship instead

# Plugins
plugins=(
    git
    brew
    macos
    docker
    python
    node
    npm
    yarn
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Environment variables
export EDITOR="code"
export BROWSER="arc"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Homebrew
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Aliases
alias ll="exa -la"
alias la="exa -la"
alias lt="exa --tree"
alias cat="bat"
alias find="fd"
alias grep="rg"
alias vim="nvim"
alias python="python3"
alias pip="pip3"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"

# Docker aliases
alias dc="docker-compose"
alias dps="docker ps"
alias di="docker images"

# Custom functions
mkcd() { mkdir -p "$1" && cd "$1"; }
