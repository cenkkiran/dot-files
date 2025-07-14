# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a comprehensive macOS dotfiles repository for automating development environment setup on MacBook Pro. It includes installation scripts, configuration files, and backup utilities designed to quickly restore a fully functional development state after a fresh format.

## Commands

### Installation & Setup
```bash
# Main installation (run from repository root)
./install.sh

# Individual component installation
./scripts/homebrew.sh     # Install Homebrew packages and casks
./scripts/python.sh       # Set up Python environment
./scripts/node.sh         # Configure Node.js environment
./scripts/mas.sh          # Install Mac App Store apps
./scripts/defaults.sh     # Apply macOS system preferences
./scripts/symlinks.sh     # Create configuration symlinks
```

### Backup Operations
```bash
# Create comprehensive system backup before formatting
./backup_script.sh

# Export current configurations
brew bundle dump --force --file=Brewfile
code --list-extensions > apps/vscode/extensions.txt
cursor --list-extensions > apps/cursor/extensions.txt
pip freeze > requirements.txt
```

### Development Tools Installed
- **Linting**: `black`, `pylint`, `flake8` (Python), `eslint`, `prettier` (JavaScript)
- **Type Checking**: `mypy` (Python), `typescript` (JavaScript)
- **Testing**: `pytest` (Python)
- **Package Management**: `poetry`, `pipenv` (Python), `yarn`, `pnpm` (Node.js)

## Architecture

### Directory Structure
- `/scripts/` - Individual installation scripts for different components
- `/config/` - Configuration files (.zshrc, .gitconfig, starship.toml)
- `/apps/` - Application-specific settings (VS Code, Cursor)
- `Brewfile` - Homebrew package manifest
- `requirements.txt` - Python packages
- `install.sh` - Master orchestration script

### Key Design Principles
1. **Modular Installation**: Each script can run independently for targeted updates
2. **Smart Defaults**: The defaults.sh script preserves current system preferences with developer-friendly alternatives commented
3. **Dual Editor Support**: Configurations for both VS Code and Cursor with analytics-focused extensions
4. **Backup First**: Comprehensive backup_script.sh creates full system snapshots before any major changes

### Installation Flow
1. Xcode Command Line Tools verification
2. Homebrew installation (with Apple Silicon detection)
3. Package installation in order: Homebrew → Python → Node.js → Mac App Store
4. Configuration symlinks creation
5. macOS preferences application
6. Application-specific configurations

### Missing Files to Add
- `config/.zshrc` - Zsh configuration file
- `config/.gitconfig` - Git configuration file
These files are referenced by symlinks.sh but not present in the repository.

## Important Notes

- Git is configured to use Cursor as the default diff/merge tool
- The repository includes untracked utility scripts:
  - `disable_conda_autoactivate.sh` - Prevents conda base auto-activation
  - `migrate_to_icloud.sh` - Migrates files from Google Drive to iCloud
  - `test_poetry_integration.sh` - Tests Poetry with Oh My Zsh
- Manual post-installation steps required for app sign-ins and license activation
- Time Machine backup recommended alongside the backup script for complete coverage