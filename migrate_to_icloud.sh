#!/bin/bash

# Google Drive to iCloud Migration Script
# Efficiently migrates files from Google Drive to iCloud Drive

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

print_status() {
    echo -e "${CYAN}[MIGRATE]${NC} $1"
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

# Migration paths
GOOGLE_DRIVE_PERSONAL="$HOME/Library/CloudStorage/GoogleDrive-cenk.kiran@gmail.com"
GOOGLE_DRIVE_WORK="$HOME/Library/CloudStorage/GoogleDrive-cenk@generation.com.tr"
ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
MIGRATION_LOG="$HOME/Desktop/migration_log_$(date +%Y%m%d_%H%M%S).txt"

print_header "Google Drive to iCloud Migration Tool"

# Check available space
print_status "Checking available space..."

# Get Google Drive sizes
if [ -d "$GOOGLE_DRIVE_PERSONAL" ]; then
    PERSONAL_SIZE=$(du -sh "$GOOGLE_DRIVE_PERSONAL" 2>/dev/null | cut -f1)
    print_status "Personal Google Drive size: $PERSONAL_SIZE"
fi

if [ -d "$GOOGLE_DRIVE_WORK" ]; then
    WORK_SIZE=$(du -sh "$GOOGLE_DRIVE_WORK" 2>/dev/null | cut -f1)
    print_status "Work Google Drive size: $WORK_SIZE"
fi

# Get iCloud available space
ICLOUD_AVAILABLE=$(df -h "$ICLOUD_DRIVE" | tail -1 | awk '{print $4}')
print_status "iCloud Drive available space: $ICLOUD_AVAILABLE"

echo "Starting migration log..." > "$MIGRATION_LOG"
echo "Migration started: $(date)" >> "$MIGRATION_LOG"
echo "========================================" >> "$MIGRATION_LOG"

print_header "Phase 1: Pre-Migration Setup"

# Create organized structure in iCloud
print_status "Creating organized folder structure in iCloud Drive..."
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive"
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Personal"
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Work"
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files"

print_success "Folder structure created"

print_header "Phase 2: Pre-Migration Analysis & Sync"

# Function to check and sync existing folders
check_and_sync_folder() {
    local google_source="$1"
    local icloud_target="$2"
    local folder_name="$3"
    
    if [ -d "$google_source" ] && [ -d "$icloud_target" ]; then
        print_status "Found $folder_name in both Google Drive and iCloud. Comparing..."
        
        if compare_directories "$google_source" "$icloud_target" "$folder_name comparison"; then
            print_success "$folder_name folders are already in sync!"
            echo "✅ $folder_name folders are identical - no sync needed" >> "$MIGRATION_LOG"
            return 0
        else
            print_warning "Differences found in $folder_name between Google Drive and iCloud"
            echo "⚠️ Sync required for $folder_name" >> "$MIGRATION_LOG"
            
            # Show what's different
            echo -e "\n${YELLOW}The following differences were detected:${NC}"
            cd "$google_source"
            find . -type f | while read -r file; do
                if [ ! -f "$icloud_target/$file" ]; then
                    echo "  - Missing in iCloud: $file"
                elif ! cmp -s "$google_source/$file" "$icloud_target/$file"; then
                    echo "  - Different content: $file"
                fi
            done | head -20
            
            echo -e "\n${YELLOW}Would you like to sync these differences to iCloud? (y/n)${NC}"
            read -r response
            
            if [[ "$response" =~ ^[Yy]$ ]]; then
                print_status "Syncing $folder_name differences to iCloud..."
                rsync -av --checksum "$google_source/" "$icloud_target/" 2>&1 | tee -a "$MIGRATION_LOG"
                print_success "$folder_name sync completed"
                return 0
            else
                print_warning "Skipping $folder_name sync"
                return 1
            fi
        fi
    elif [ -d "$google_source" ] && [ ! -d "$icloud_target" ]; then
        print_status "$folder_name exists in Google Drive but not in iCloud"
        return 2
    else
        return 3
    fi
}

# Check for existing Documents folders and other common folders
print_status "Checking for existing folders that may need syncing..."

# Check Work Documents
if [ -d "$GOOGLE_DRIVE_WORK/My Drive/Documents" ]; then
    check_and_sync_folder "$GOOGLE_DRIVE_WORK/My Drive/Documents" "$ICLOUD_DRIVE/Documents" "Work Documents"
fi

# Check Personal Documents
if [ -d "$GOOGLE_DRIVE_PERSONAL/My Drive/Documents" ]; then
    check_and_sync_folder "$GOOGLE_DRIVE_PERSONAL/My Drive/Documents" "$ICLOUD_DRIVE/Documents" "Personal Documents"
fi

# Check other important folders that might already exist in iCloud
important_folders=("Projects" "Archive" "Work" "Personal")
for folder in "${important_folders[@]}"; do
    if [ -d "$GOOGLE_DRIVE_WORK/My Drive/$folder" ]; then
        check_and_sync_folder "$GOOGLE_DRIVE_WORK/My Drive/$folder" "$ICLOUD_DRIVE/$folder" "$folder (Work)"
    fi
    if [ -d "$GOOGLE_DRIVE_PERSONAL/My Drive/$folder" ]; then
        check_and_sync_folder "$GOOGLE_DRIVE_PERSONAL/My Drive/$folder" "$ICLOUD_DRIVE/$folder" "$folder (Personal)"
    fi
done

print_header "Phase 3: Smart Migration Strategy"

# Function to compare directories using checksums
compare_directories() {
    local source="$1"
    local destination="$2"
    local comparison_name="$3"
    
    print_status "Performing checksum comparison for $comparison_name..."
    
    # Create temporary files for checksums
    local source_checksums="/tmp/source_checksums_$(date +%s).txt"
    local dest_checksums="/tmp/dest_checksums_$(date +%s).txt"
    local diff_report="/tmp/diff_report_$(date +%s).txt"
    
    # Generate checksums for source
    print_status "Calculating checksums for source directory..."
    cd "$source" && find . -type f -exec md5 -q {} \; | sort > "$source_checksums" 2>/dev/null
    local source_files=$(find "$source" -type f | wc -l | tr -d ' ')
    
    # Generate checksums for destination
    print_status "Calculating checksums for destination directory..."
    cd "$destination" && find . -type f -exec md5 -q {} \; | sort > "$dest_checksums" 2>/dev/null
    local dest_files=$(find "$destination" -type f | wc -l | tr -d ' ')
    
    # Compare checksums
    if diff "$source_checksums" "$dest_checksums" > "$diff_report" 2>&1; then
        print_success "Checksum verification passed: All files match"
        echo "✅ $comparison_name: Checksum verification passed ($source_files files)" >> "$MIGRATION_LOG"
        rm -f "$source_checksums" "$dest_checksums" "$diff_report"
        return 0
    else
        print_warning "Checksum differences detected"
        echo "⚠️ $comparison_name: Checksum mismatch detected" >> "$MIGRATION_LOG"
        
        # Find missing files
        print_status "Identifying missing or different files..."
        cd "$source"
        find . -type f | while read -r file; do
            if [ ! -f "$destination/$file" ]; then
                echo "Missing in destination: $file" >> "$MIGRATION_LOG"
                print_warning "Missing: $file"
            elif ! cmp -s "$source/$file" "$destination/$file"; then
                echo "Different content: $file" >> "$MIGRATION_LOG"
                print_warning "Different: $file"
            fi
        done
        
        rm -f "$source_checksums" "$dest_checksums" "$diff_report"
        return 1
    fi
}

# Function to migrate with progress and verification
migrate_folder() {
    local source="$1"
    local destination="$2"
    local folder_name="$3"
    
    if [ ! -d "$source" ]; then
        print_warning "Source folder does not exist: $source"
        return 1
    fi
    
    print_status "Migrating $folder_name..."
    echo "Migrating $folder_name from $source to $destination" >> "$MIGRATION_LOG"
    
    # Use rsync for efficient copying with progress
    if rsync -av --progress --partial "$source/" "$destination/" 2>&1 | tee -a "$MIGRATION_LOG"; then
        print_success "$folder_name migrated successfully"
        
        # Verify the migration
        SOURCE_COUNT=$(find "$source" -type f | wc -l)
        DEST_COUNT=$(find "$destination" -type f | wc -l)
        
        if [ "$SOURCE_COUNT" -eq "$DEST_COUNT" ]; then
            print_success "Verification passed: $SOURCE_COUNT files migrated"
            echo "✅ $folder_name: $SOURCE_COUNT files verified" >> "$MIGRATION_LOG"
            
            # Perform checksum comparison
            if compare_directories "$source" "$destination" "$folder_name"; then
                return 0
            else
                print_warning "Checksum verification failed - attempting sync of missing files"
                # Sync any missing or different files
                rsync -av --checksum "$source/" "$destination/" 2>&1 | tee -a "$MIGRATION_LOG"
                return 0
            fi
        else
            print_warning "File count mismatch: Source($SOURCE_COUNT) vs Destination($DEST_COUNT)"
            echo "⚠️ $folder_name: File count mismatch" >> "$MIGRATION_LOG"
            return 1
        fi
    else
        print_error "Migration failed for $folder_name"
        echo "❌ $folder_name: Migration failed" >> "$MIGRATION_LOG"
        return 1
    fi
}

# Function to migrate important files selectively
migrate_important_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local description="$3"
    
    print_status "Scanning $description for important files..."
    
    # Important file extensions to prioritize
    important_extensions=("pdf" "docx" "xlsx" "pptx" "txt" "md" "png" "jpg" "jpeg" "zip" "key" "numbers" "pages")
    
    for ext in "${important_extensions[@]}"; do
        if find "$source_dir" -name "*.$ext" -type f | head -1 > /dev/null 2>&1; then
            print_status "Found .$ext files in $description"
            find "$source_dir" -name "*.$ext" -type f -exec cp {} "$dest_dir/" \; 2>/dev/null || true
        fi
    done
}

print_header "Phase 4: Selective Migration"

# Migrate Google Drive Personal
if [ -d "$GOOGLE_DRIVE_PERSONAL" ]; then
    print_status "Processing Personal Google Drive..."
    
    # Check if My Drive exists
    if [ -d "$GOOGLE_DRIVE_PERSONAL/My Drive" ]; then
        migrate_folder "$GOOGLE_DRIVE_PERSONAL/My Drive" "$ICLOUD_DRIVE/Migrated from Google Drive/Personal" "Personal Google Drive"
    else
        print_warning "My Drive folder not found in personal Google Drive"
    fi
else
    print_warning "Personal Google Drive not found"
fi

# Migrate Google Drive Work
if [ -d "$GOOGLE_DRIVE_WORK" ]; then
    print_status "Processing Work Google Drive..."
    
    if [ -d "$GOOGLE_DRIVE_WORK/My Drive" ]; then
        migrate_folder "$GOOGLE_DRIVE_WORK/My Drive" "$ICLOUD_DRIVE/Migrated from Google Drive/Work" "Work Google Drive"
    else
        print_warning "My Drive folder not found in work Google Drive"
    fi
else
    print_warning "Work Google Drive not found"
fi

print_header "Phase 5: Clean Up Desktop Files"

# Migrate important files from Desktop that might be scattered
print_status "Organizing Desktop files..."

# Create categories for better organization
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Documents"
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Screenshots"
mkdir -p "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Projects"

# Move PDF documents
find "$HOME/Desktop" -name "*.pdf" -type f -exec mv {} "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Documents/" \; 2>/dev/null || true

# Move screenshots and images
find "$HOME/Desktop" -name "CleanShot*" -type f -exec mv {} "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Screenshots/" \; 2>/dev/null || true
find "$HOME/Desktop" -name "SCR-*" -type f -exec mv {} "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Screenshots/" \; 2>/dev/null || true

# Move project folders
for folder in "CV" "BMW Stolen" "Sarp Consultancy" "VISA-2023" "Schengen 2025"; do
    if [ -d "$HOME/Desktop/$folder" ]; then
        mv "$HOME/Desktop/$folder" "$ICLOUD_DRIVE/Migrated from Google Drive/Desktop Files/Projects/" 2>/dev/null || true
        print_status "Moved $folder to iCloud"
    fi
done

print_success "Desktop files organized"

print_header "Phase 6: Migration Summary and Verification"

# Generate comprehensive report
echo "" >> "$MIGRATION_LOG"
echo "========================================" >> "$MIGRATION_LOG"
echo "Migration completed: $(date)" >> "$MIGRATION_LOG"
echo "========================================" >> "$MIGRATION_LOG"

# Count migrated files
TOTAL_FILES=$(find "$ICLOUD_DRIVE/Migrated from Google Drive" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$ICLOUD_DRIVE/Migrated from Google Drive" | cut -f1)

echo "Total files migrated: $TOTAL_FILES" >> "$MIGRATION_LOG"
echo "Total size migrated: $TOTAL_SIZE" >> "$MIGRATION_LOG"

print_success "Migration completed!"
print_success "Files migrated: $TOTAL_FILES"
print_success "Total size: $TOTAL_SIZE"
print_status "Migration log saved to: $MIGRATION_LOG"

print_header "Phase 7: Post-Migration Steps"

cat << 'EOF'
📋 NEXT STEPS TO COMPLETE MIGRATION:

1. ✅ VERIFY YOUR FILES:
   - Open Finder → iCloud Drive → "Migrated from Google Drive"
   - Check that your important files are there
   - Test opening a few documents to ensure they work

2. 🔄 CONFIGURE APPLICATIONS:
   - Update any apps that sync with Google Drive to use iCloud instead
   - Update bookmark/shortcuts that point to Google Drive locations

3. 📱 MOBILE DEVICES:
   - Ensure iCloud Drive is enabled on iPhone/iPad
   - Your files will automatically sync to all devices

4. 🗑️ CLEAN UP (ONLY AFTER VERIFICATION):
   - Once you're confident everything is migrated:
   - Sign out of Google Drive on this Mac
   - Uninstall Google Drive for Desktop application
   - Clean up any remaining Google Drive folders

5. 📊 CHECK ICLOUD STORAGE:
   - Apple Menu → System Settings → [Your Name] → iCloud
   - Monitor your iCloud storage usage
   - Consider upgrading iCloud+ plan if needed

6. 🔐 UPDATE SHARING:
   - Re-share any documents with colleagues using iCloud links
   - Update any shared folder access

EOF

# Open iCloud Drive to show results
print_status "Opening iCloud Drive to show migrated files..."
open "$ICLOUD_DRIVE/Migrated from Google Drive"

print_warning "⚠️  IMPORTANT: Verify all files before removing Google Drive!"
echo ""
print_success "Migration script completed successfully!"
