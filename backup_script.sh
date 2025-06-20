#!/bin/bash

# MacBook Pro Comprehensive Backup Script
# This script creates a complete backup of your system before refresh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_status() {
    echo -e "${BLUE}[BACKUP]${NC} $1"
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

# Get current date for backup folder
BACKUP_DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$HOME/MacBook_Backup_$BACKUP_DATE"
DOTFILES_BACKUP="$HOME/.dotfiles/backup"

print_header "MacBook Pro Backup Script"
print_status "Creating backup directory: $BACKUP_DIR"

# Create backup directories
mkdir -p "$BACKUP_DIR"/{system,applications,development,documents,settings}
mkdir -p "$DOTFILES_BACKUP"

print_header "Phase 1: System Information & Package Lists"

# System information
print_status "Gathering system information..."
system_info() {
    echo "=== System Information ===" > "$BACKUP_DIR/system/system_info.txt"
    sw_vers >> "$BACKUP_DIR/system/system_info.txt"
    echo "" >> "$BACKUP_DIR/system/system_info.txt"
    echo "=== Hardware Information ===" >> "$BACKUP_DIR/system/system_info.txt"
    system_profiler SPHardwareDataType >> "$BACKUP_DIR/system/system_info.txt"
    echo "" >> "$BACKUP_DIR/system/system_info.txt"
    echo "=== Disk Usage ===" >> "$BACKUP_DIR/system/system_info.txt"
    df -h >> "$BACKUP_DIR/system/system_info.txt"
}
system_info
print_success "System information saved"

# Homebrew packages
print_status "Backing up Homebrew packages..."
if command -v brew &> /dev/null; then
    brew bundle dump --force --file="$BACKUP_DIR/applications/Brewfile"
    brew list --formula > "$BACKUP_DIR/applications/brew_formulas.txt"
    brew list --cask > "$BACKUP_DIR/applications/brew_casks.txt"
    brew services list > "$BACKUP_DIR/applications/brew_services.txt"
    print_success "Homebrew packages backed up"
else
    print_warning "Homebrew not found"
fi

# Python packages
print_status "Backing up Python packages..."
if command -v pip3 &> /dev/null; then
    pip3 freeze > "$BACKUP_DIR/development/pip_packages.txt"
    print_success "Python packages backed up"
fi

if command -v conda &> /dev/null; then
    conda list --export > "$BACKUP_DIR/development/conda_packages.txt"
    conda env list > "$BACKUP_DIR/development/conda_environments.txt"
    print_success "Conda packages backed up"
fi

# Node.js packages
print_status "Backing up Node.js packages..."
if command -v npm &> /dev/null; then
    npm list -g --depth=0 > "$BACKUP_DIR/development/npm_global_packages.txt" 2>/dev/null || true
    print_success "Node.js packages backed up"
fi

# VS Code extensions
print_status "Backing up VS Code extensions..."
if command -v code &> /dev/null; then
    code --list-extensions > "$BACKUP_DIR/applications/vscode_extensions.txt"
    print_success "VS Code extensions backed up"
fi

# Mac App Store apps
print_status "Backing up Mac App Store apps..."
if command -v mas &> /dev/null; then
    mas list > "$BACKUP_DIR/applications/mas_apps.txt"
    print_success "Mac App Store apps backed up"
else
    print_warning "mas CLI not found - install with: brew install mas"
fi

# Applications list
print_status "Creating applications inventory..."
ls -la /Applications > "$BACKUP_DIR/applications/applications_list.txt"
find /Applications -name "*.app" -maxdepth 1 | sort > "$BACKUP_DIR/applications/installed_apps.txt"
print_success "Applications inventory created"

print_header "Phase 2: Configuration Files & Settings"

# SSH keys and config
print_status "Backing up SSH configuration..."
if [ -d "$HOME/.ssh" ]; then
    cp -R "$HOME/.ssh" "$BACKUP_DIR/settings/"
    chmod -R 600 "$BACKUP_DIR/settings/.ssh"
    print_success "SSH configuration backed up"
else
    print_warning "No SSH directory found"
fi

# Git configuration
print_status "Backing up Git configuration..."
if [ -f "$HOME/.gitconfig" ]; then
    cp "$HOME/.gitconfig" "$BACKUP_DIR/settings/"
    print_success "Git configuration backed up"
fi

if [ -f "$HOME/.gitignore_global" ]; then
    cp "$HOME/.gitignore_global" "$BACKUP_DIR/settings/"
fi

# Shell configuration
print_status "Backing up shell configuration..."
for file in .zshrc .bashrc .bash_profile .profile .zprofile; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/settings/"
        print_status "Backed up $file"
    fi
done

# Development directories
print_status "Backing up development configurations..."
for dir in .pyenv .nvm .rbenv .cargo .rustup; do
    if [ -d "$HOME/$dir" ]; then
        cp -R "$HOME/$dir" "$BACKUP_DIR/development/" 2>/dev/null || true
        print_status "Backed up $dir"
    fi
done

# Application preferences (selective)
print_status "Backing up application preferences..."
mkdir -p "$BACKUP_DIR/settings/app_preferences"

# Important app preferences to backup
declare -a important_prefs=(
    "com.raycast.macos"
    "com.1password.1password"
    "com.sublimetext.4"
    "com.googlecode.iterm2"
    "dev.warp.Warp-Stable"
    "company.thebrowser.Browser"
    "com.tinyspeck.slackmacgap"
    "notion.id"
    "md.obsidian"
)

for pref in "${important_prefs[@]}"; do
    if defaults read "$pref" &>/dev/null; then
        defaults export "$pref" "$BACKUP_DIR/settings/app_preferences/$pref.plist" 2>/dev/null || true
        print_status "Exported preferences for $pref"
    fi
done

print_success "Application preferences backed up"

print_header "Phase 3: Important Documents & Data"

# Important directories to backup
print_status "Backing up important documents..."
declare -a important_dirs=(
    "Desktop"
    "Documents" 
    "Downloads"
)

for dir in "${important_dirs[@]}"; do
    if [ -d "$HOME/$dir" ] && [ "$(ls -A "$HOME/$dir" 2>/dev/null)" ]; then
        print_status "Backing up $dir (this may take a while)..."
        rsync -av --progress "$HOME/$dir/" "$BACKUP_DIR/documents/$dir/" 2>/dev/null || {
            print_warning "Some files in $dir couldn't be backed up (permissions or in use)"
        }
        print_success "$dir backed up"
    else
        print_warning "$dir is empty or doesn't exist"
    fi
done

print_header "Phase 4: Browser Data"

# Safari bookmarks
print_status "Backing up Safari bookmarks..."
if [ -f "$HOME/Library/Safari/Bookmarks.plist" ]; then
    cp "$HOME/Library/Safari/Bookmarks.plist" "$BACKUP_DIR/settings/"
    print_success "Safari bookmarks backed up"
fi

# Chrome bookmarks (if exists)
print_status "Backing up Chrome bookmarks..."
CHROME_DIR="$HOME/Library/Application Support/Google/Chrome/Default"
if [ -f "$CHROME_DIR/Bookmarks" ]; then
    mkdir -p "$BACKUP_DIR/settings/chrome"
    cp "$CHROME_DIR/Bookmarks" "$BACKUP_DIR/settings/chrome/"
    cp "$CHROME_DIR/Preferences" "$BACKUP_DIR/settings/chrome/" 2>/dev/null || true
    print_success "Chrome bookmarks backed up"
fi

# Arc bookmarks (if exists)
print_status "Backing up Arc bookmarks..."
ARC_DIR="$HOME/Library/Application Support/Arc"
if [ -d "$ARC_DIR" ]; then
    mkdir -p "$BACKUP_DIR/settings/arc"
    cp -R "$ARC_DIR" "$BACKUP_DIR/settings/" 2>/dev/null || true
    print_success "Arc data backed up"
fi

print_header "Phase 5: Development Projects"

# Look for common development directories
print_status "Scanning for development projects..."
declare -a dev_dirs=(
    "Projects"
    "Code" 
    "Development"
    "GitHub"
    "repos"
    "workspace"
)

for dir in "${dev_dirs[@]}"; do
    if [ -d "$HOME/$dir" ]; then
        print_warning "Found development directory: $HOME/$dir"
        echo "This contains code projects - consider backing up manually or via Git"
        echo "$HOME/$dir" >> "$BACKUP_DIR/documents/development_directories.txt"
    fi
done

print_header "Phase 6: Creating Restore Instructions"

# Create restore instructions
cat > "$BACKUP_DIR/RESTORE_INSTRUCTIONS.md" << 'EOF'
# MacBook Pro Restore Instructions

## Before Restoring
1. Set up fresh macOS installation
2. Sign in to App Store
3. Install Xcode Command Line Tools: `xcode-select --install`

## Restore Order

### 1. System Packages
```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Restore packages
brew bundle --file=applications/Brewfile
```

### 2. Development Environment
```bash
# Python packages
pip3 install -r development/pip_packages.txt

# Node.js packages
cat development/npm_global_packages.txt | grep -E '^[^─└├]' | awk '{print $1}' | xargs npm install -g

# VS Code extensions
cat applications/vscode_extensions.txt | xargs -n 1 code --install-extension
```

### 3. Configuration Files
```bash
# Copy configurations back
cp settings/.gitconfig ~/
cp settings/.zshrc ~/
cp -R settings/.ssh ~/
chmod 600 ~/.ssh/id_* 2>/dev/null || true
```

### 4. Application Preferences
```bash
# Import app preferences
for pref in settings/app_preferences/*.plist; do
    app_name=$(basename "$pref" .plist)
    defaults import "$app_name" "$pref"
done
```

### 5. Documents
- Manually copy documents/ folder contents to appropriate locations
- Review development_directories.txt for code projects to restore

## Manual Steps Required
- Sign in to all applications (1Password, Slack, etc.)
- Re-authenticate cloud services
- Import browser bookmarks if needed
- Activate software licenses
EOF

print_success "Restore instructions created"

print_header "Phase 7: Backup Summary"

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)

# Create backup manifest
cat > "$BACKUP_DIR/BACKUP_MANIFEST.txt" << EOF
MacBook Pro Backup Created: $(date)
Backup Location: $BACKUP_DIR
Backup Size: $BACKUP_SIZE
macOS Version: $(sw_vers -productVersion)
Computer: $(scutil --get ComputerName)

Contents:
- System information and package lists
- Application preferences and configurations  
- SSH keys and Git configuration
- Shell configurations (.zshrc, etc.)
- Browser bookmarks and data
- Important documents (Desktop, Documents, Downloads)
- Development environment configurations

Files included:
$(find "$BACKUP_DIR" -type f | wc -l) files
$(find "$BACKUP_DIR" -type d | wc -l) directories

Next Steps:
1. Review backup contents in: $BACKUP_DIR
2. Create Time Machine backup
3. Upload important files to cloud storage
4. Test restore process if desired
EOF

print_header "BACKUP COMPLETE!"
print_success "Backup created in: $BACKUP_DIR"
print_success "Backup size: $BACKUP_SIZE"
echo ""
print_status "Next steps:"
echo "1. Review the backup contents"
echo "2. Create a Time Machine backup"
echo "3. Consider uploading to cloud storage"
echo "4. Read RESTORE_INSTRUCTIONS.md before formatting"
echo ""
print_warning "Important: Test your backup before formatting your Mac!"

# Open backup directory
open "$BACKUP_DIR"
