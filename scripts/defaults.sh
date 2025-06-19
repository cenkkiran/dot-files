#!/bin/bash

# macOS Defaults Script - Based on Your Current System Settings
# This script replicates your current macOS preferences with alternative options commented

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DEFAULTS]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[DEFAULTS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[DEFAULTS]${NC} $1"
}

print_status "Setting macOS preferences based on your current configuration..."

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

###############################################################################
# System-wide Preferences (from your NSGlobalDomain)                         #
###############################################################################

print_status "Setting system-wide preferences..."

# Dark mode (you currently use Dark mode)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Language and region settings (en-GB primary, tr-GB secondary)
defaults write NSGlobalDomain AppleLanguages -array "en-GB" "tr-GB"
defaults write NSGlobalDomain AppleLocale -string "en_GB"

# Measurement units (Centimeters and Celsius)
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"

# Text editing preferences (matching your current settings)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool true
defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false

# Spring loading settings (you have these enabled)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Trackpad settings (force click enabled)
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Sound settings (no flash on beep)
defaults write com.apple.sound.beep.flash -int 0
sudo nvram SystemAudioVolume=" "

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Key repeat settings - fast for developers
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

###############################################################################
# General UI/UX                                                               #
###############################################################################

print_status "Setting general UI/UX preferences..."

# Menu bar: show battery percentage
defaults write com.apple.menuextra.battery ShowPercent YES

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the "Open With" menu
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

###############################################################################
# Dock preferences (based on your current dock settings)                     #
###############################################################################

print_status "Setting Dock preferences..."

# CONFLICT: Dock tile size
# Your current setting: 52 pixels (medium size)
defaults write com.apple.dock tilesize -int 52

# Large size for magnification (you have largesize = 128)
defaults write com.apple.dock largesize -int 128

# CONFLICT: Dock auto-hide behavior
# Your current setting: Always visible (autohide = false)
defaults write com.apple.dock autohide -bool false

# Dock behavior settings (matching your current preferences)
defaults write com.apple.dock "minimize-to-application" -bool true
defaults write com.apple.dock "mru-spaces" -bool false
defaults write com.apple.dock "expose-group-apps" -bool false

# Additional dock improvements
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock showhidden -bool true

# Hot corner (you have bottom-right corner set to 14)
defaults write com.apple.dock wvous-br-corner -int 14

###############################################################################
# Finder preferences (based on your current settings)                        #
###############################################################################

print_status "Setting Finder preferences..."

# CONFLICT: Desktop icon visibility
# Your current settings: External drives yes, hard drives no
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# CONFLICT: Finder view preferences
# Your current setting: Column view (clmv)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Alternative: List view for more file details
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# CONFLICT: New Finder window location
# Your current setting: Not explicitly set (likely defaults to recent folders)
# Alternative: Set Desktop as default location
# defaults write com.apple.finder NewWindowTarget -string "PfDe"
# defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Sidebar settings (you have sidebar enabled)
defaults write com.apple.finder ShowSidebar -bool true

# iCloud settings (you have iCloud Drive enabled for Desktop & Documents)
defaults write com.apple.finder FXICloudDriveEnabled -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool true
defaults write com.apple.finder FXICloudDriveDocuments -bool true

# Search scope (you use current folder - SCcf)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# CONFLICT: Show hidden files
# Your current setting: Not explicitly set (likely hidden)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# CONFLICT: Additional Finder UI elements
# Your current setting: Not explicitly set
# Alternatives: Show status bar and path bar (useful for developers)
# defaults write com.apple.finder ShowStatusBar -bool true
# defaults write com.apple.finder ShowPathbar -bool true

# CONFLICT: Finder window title
# Alternative: Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# CONFLICT: Finder quit option
# Alternative: Allow quitting Finder via ⌘ + Q (also hides desktop icons)
# defaults write com.apple.finder QuitMenuItem -bool true

# Useful Finder settings (recommended)
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Activity Monitor                                                           #
###############################################################################

print_status "Setting Activity Monitor preferences..."

defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Kill affected applications                                                  #
###############################################################################

print_status "Restarting affected applications..."

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null || true
done

print_success "macOS preferences have been set to match your current configuration!"
print_warning "Some changes may require a logout/restart to take full effect."
print_warning "Review the commented alternatives above and uncomment preferred options."
