# MacBook Pro Backup Checklist

## 🚀 Quick Start
```bash
cd ~/.dotfiles
./backup_script.sh
```

## ✅ What Gets Backed Up Automatically

### 📦 **Package Lists**
- Homebrew packages and casks (`Brewfile`)
- Python packages (`pip freeze`)
- Node.js global packages
- VS Code extensions
- Mac App Store apps
- Conda environments (if installed)

### ⚙️ **Configurations**
- SSH keys and config
- Git configuration (`.gitconfig`)
- Shell configs (`.zshrc`, `.bashrc`, etc.)
- Application preferences for key apps:
  - Raycast, 1Password, Sublime Text
  - iTerm2, Warp, Arc browser
  - Slack, Notion, Obsidian

### 📁 **Important Data**
- Desktop, Documents, Downloads folders
- Safari and Chrome bookmarks
- Arc browser data
- Development environment configs

### 📋 **System Info**
- macOS version and hardware info
- Disk usage and system state
- Complete restore instructions

## 📋 **Manual Backup Checklist**

Before running the script, handle these manually:

### 🔐 **Critical Security Items**
- [ ] Export passwords from 1Password/browser
- [ ] Save 2FA backup codes
- [ ] Note down software license keys
- [ ] Export certificates if any

### 💼 **Work/Personal Data**
- [ ] Check active projects for uncommitted changes
- [ ] Backup any local databases
- [ ] Export email if using local client
- [ ] Save any custom app themes/plugins

### ☁️ **Cloud Sync Status**
- [ ] Ensure Google Drive is fully synced
- [ ] Check OneDrive sync status
- [ ] Verify iCloud is up to date
- [ ] Wait for any pending uploads

### 📱 **Device-Specific**
- [ ] Export iPhone/iPad apps that sync to Mac
- [ ] Note down any paired Bluetooth devices
- [ ] Screenshot current desktop layout
- [ ] Export any custom shortcuts/automations

## 🎯 **Time Machine + Script Strategy**

**Most Efficient Approach:**
1. **Start Time Machine backup** (runs in background)
2. **Run backup script** (captures configurations)
3. **Manual items** while Time Machine runs
4. **Upload critical files** to cloud

**Estimated Times:**
- Backup script: 5-10 minutes
- Time Machine: 1-4 hours (first time)
- Manual items: 30 minutes

## 🔄 **After Running Backup Script**

You'll get a folder like: `~/MacBook_Backup_20250619_143022/`

**Contents:**
```
├── system/           # System info and hardware details
├── applications/     # All package lists and app inventory  
├── development/      # Python, Node, dev environment configs
├── documents/        # Desktop, Documents, Downloads
├── settings/         # SSH, Git, shell, app preferences
├── RESTORE_INSTRUCTIONS.md
└── BACKUP_MANIFEST.txt
```

**Review:**
- Check backup size is reasonable
- Verify important files are included
- Test opening a few backed up configs

## 🛡️ **Backup Verification**

Before formatting, verify you can:
- [ ] Open and read backed up configs
- [ ] See your important documents
- [ ] Access SSH keys (but don't test - just verify files exist)
- [ ] Read the package lists

## 📤 **Cloud Upload Recommendation**

Upload these to cloud storage:
- [ ] Entire backup folder (for speed)
- [ ] SSH keys separately (encrypted)
- [ ] Any critical work files separately

**Estimated upload time:** 30 minutes - 2 hours depending on size and connection
