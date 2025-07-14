#!/bin/zsh

# Script to disable conda base auto-activation

echo "🐍 Disabling conda base auto-activation..."

# Method 1: Use conda config command
if command -v conda &> /dev/null; then
    echo "✅ Found conda, disabling auto-activation..."
    conda config --set auto_activate_base false
    echo "✅ Conda auto-activation disabled via conda config"
else
    echo "⚠️  Conda command not found in current session"
fi

# Method 2: Edit .condarc file directly
CONDARC_FILE="$HOME/.condarc"

if [ -f "$CONDARC_FILE" ]; then
    echo "📝 Found existing .condarc file"
    
    # Check if auto_activate_base is already set
    if grep -q "auto_activate_base" "$CONDARC_FILE"; then
        # Update existing setting
        sed -i '' 's/auto_activate_base:.*/auto_activate_base: false/' "$CONDARC_FILE"
        echo "🔄 Updated existing auto_activate_base setting to false"
    else
        # Add new setting
        echo "auto_activate_base: false" >> "$CONDARC_FILE"
        echo "➕ Added auto_activate_base: false to .condarc"
    fi
else
    echo "📝 Creating new .condarc file..."
    echo "auto_activate_base: false" > "$CONDARC_FILE"
    echo "✅ Created .condarc with auto_activate_base: false"
fi

# Method 3: Add conda deactivate to .zshrc for immediate effect
echo ""
echo "🔧 Adding conda deactivate to .zshrc for immediate effect..."

# Check if conda deactivate is already in .zshrc
if ! grep -q "conda deactivate" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Disable conda base environment auto-activation" >> ~/.zshrc
    echo "# This runs after conda init to immediately deactivate base" >> ~/.zshrc
    echo "if command -v conda &> /dev/null && [[ \$CONDA_DEFAULT_ENV == \"base\" ]]; then" >> ~/.zshrc
    echo "    conda deactivate" >> ~/.zshrc
    echo "fi" >> ~/.zshrc
    echo "✅ Added conda deactivate logic to .zshrc"
else
    echo "ℹ️  Conda deactivate logic already exists in .zshrc"
fi

echo ""
echo "🎉 Conda base auto-activation has been disabled!"
echo ""
echo "📋 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Your prompt should now only show Poetry environments"
echo "3. To manually activate conda when needed: conda activate base"
echo ""
echo "🎭 Your prompt will now look like:"
echo "   ➜ kapow_dbt 🎭 kapow-dbt-lKrBil4A-py3.12"
echo "   (instead of showing base and system as well)"
