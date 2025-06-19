# MacBook Pro Dotfiles

Automated setup for macOS development environment. This repository contains scripts and configurations to quickly restore your MacBook Pro to a fully functional development state after a fresh format.

## 📋 What Gets Installed

### Development Tools
- **Code Editors**: VS Code, Cursor, Sublime Text
- **Terminals**: iTerm2
- **Languages**: Python 3.12, Node.js (LTS)
- **Tools**: Docker, Git, Homebrew, various CLI utilities

### Productivity Apps
- **Window Management**: Magnet, AltTab, BetterDisplay
- **Utilities**: Raycast, 1Password, CleanShot X, Bartender 5
- **Notes & Documents**: Notion, Obsidian, Joplin
- **Communication**: Slack, Zoom, WhatsApp

### System Configurations
- Zsh with Oh My Zsh + plugins
- Starship prompt (customizable)
- Git configuration (with Cursor integration)
- macOS system preferences (based on current settings)
- Application settings for both VS Code and Cursor

## 🚀 Quick Start

1. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Make the script executable**:
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation**:
   ```bash
   ./install.sh
   ```

4. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## 📁 Repository Structure

```
.dotfiles/
├── install.sh              # Main installation script
├── Brewfile                # Homebrew packages and applications
├── requirements.txt        # Python packages
├── README.md               # This file
├── config/                 # Configuration files
│   ├── .zshrc             # Zsh configuration (Starship prompt)
│   ├── .gitconfig         # Git configuration (Cursor integration)
│   └── starship.toml      # Starship prompt config
├── scripts/               # Individual installation scripts
│   ├── homebrew.sh        # Homebrew packages
│   ├── python.sh          # Python environment
│   ├── node.sh            # Node.js environment
│   ├── mas.sh             # Mac App Store apps
│   ├── defaults.sh        # macOS preferences
│   └── symlinks.sh        # Create symbolic links
└── apps/                  # Application-specific configs
    ├── vscode/            # VS Code settings and extensions
    │   ├── settings.json
    │   └── extensions.txt
    └── cursor/            # Cursor settings and extensions
        └── extensions.txt
```

## 🔧 Customization

### Before Running

1. **Update Git configuration**:
   Edit `config/.gitconfig` and update your name and email:
   ```bash
   nano ~/.dotfiles/config/.gitconfig
   ```

2. **Review Brewfile**:
   Check `Brewfile` and comment out any applications you don't need:
   ```bash
   nano ~/.dotfiles/Brewfile
   ```

3. **Mac App Store**:
   Make sure you're signed in to the App Store before running the script.

### Adding Your Own Configurations

- **Shell aliases**: Add to `config/.zshrc`
- **Git aliases**: Add to `config/.gitconfig`  
- **Python packages**: Add to `requirements.txt`
- **Homebrew packages**: Add to `Brewfile`
- **VS Code extensions**: Add to `apps/vscode/extensions.txt`
- **Cursor extensions**: Add to `apps/cursor/extensions.txt`

## 🎯 Key Features

### Smart macOS Defaults
The `defaults.sh` script is intelligently designed to:
- Apply your current system preferences as the primary settings
- Include commented alternatives for developer-friendly options
- Highlight conflicts with clear `# CONFLICT:` markers
- Allow easy customization by uncommenting preferred alternatives

### Dual Editor Support
- **VS Code**: Traditional development setup with themes and productivity extensions
- **Cursor**: AI-enhanced development with specialized extensions for analytics and data work

### Git Integration
- Pre-configured with Cursor as the default diff and merge tool
- Comprehensive aliases for efficient git workflow
- Color-coded output for better readability

### Analytics-Focused Extensions
Special focus on data and analytics development:
- **dbt Power User** for data transformation
- **BigQuery, PostgreSQL, MySQL** drivers
- **Data Wrangler** for data analysis
- **Jupyter** support with full extension suite

## 📝 Manual Steps After Installation

Some applications require manual configuration:

1. **Sign in to applications**:
   - 1Password
   - Slack workspaces
   - Notion
   - Cloud storage (Google Drive, OneDrive)

2. **Import application settings**:
   - Raycast settings
   - CleanShot X preferences
   - Terminal themes and profiles

3. **Development environments**:
   - SSH keys setup
   - AWS credentials
   - Database connections

4. **Configure Cursor**:
   - Sign in to Cursor account
   - Import settings if migrating from VS Code
   - Set up AI features and preferences

## 🔄 Keeping Dotfiles Updated

### Export Current Settings

1. **Homebrew packages**:
   ```bash
   brew bundle dump --force --file=~/.dotfiles/Brewfile
   ```

2. **VS Code extensions**:
   ```bash
   code --list-extensions > ~/.dotfiles/apps/vscode/extensions.txt
   ```

3. **Cursor extensions**:
   ```bash
   cursor --list-extensions > ~/.dotfiles/apps/cursor/extensions.txt
   ```

4. **Python packages**:
   ```bash
   pip freeze > ~/.dotfiles/requirements.txt
   ```

### Backup Current Configs

The installation script automatically backs up existing configurations to:
```
~/.dotfiles_backup_YYYYMMDD_HHMMSS/
```

## 🛠 Troubleshooting

### Common Issues

1. **Homebrew installation fails**:
   - Make sure Xcode Command Line Tools are installed
   - Check your internet connection

2. **Mac App Store apps don't install**:
   - Sign in to the App Store first
   - Some apps might have different IDs in different regions

3. **Permission errors**:
   - The script will ask for sudo password when needed
   - Make sure you have admin privileges

4. **Cursor configuration**:
   - Make sure Cursor is installed via Homebrew first
   - Extensions will be installed during the main installation process

### Manual Installation

If the automated script fails, you can run individual components:

```bash
# Install Homebrew packages only
./scripts/homebrew.sh

# Set up Python environment only  
./scripts/python.sh

# Create symlinks only
./scripts/symlinks.sh

# Set macOS preferences only
./scripts/defaults.sh
```

### macOS Defaults Customization

The `defaults.sh` script includes intelligent conflict resolution:
- Your current settings are always applied by default
- Alternative options are commented with explanations
- Look for `# CONFLICT:` markers to identify customization points
- Uncomment preferred alternatives before running the script

## 📱 Applications Not in Homebrew

Some applications need to be installed manually:

- **Ghostty**: Download from official website
- **Grammarly Desktop**: Download from official website

## 🔍 What's New

### Recent Updates
- ✅ Added Cursor extensions configuration
- ✅ Updated Git configuration for Cursor integration
- ✅ Enhanced defaults script with conflict-aware settings
- ✅ Improved repository structure documentation
- ✅ Added analytics-focused extension support
- ✅ Enhanced Starship prompt configuration

## 🤝 Contributing

Feel free to fork this repository and customize it for your own needs. If you find improvements or fixes, pull requests are welcome!

## 📄 License

This project is open source and available under the MIT License.
