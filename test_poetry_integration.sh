#!/bin/zsh

# Test script to verify Poetry integration with oh-my-zsh

echo "🔧 Testing Poetry integration with oh-my-zsh..."

# Check if Poetry is available
if command -v poetry &> /dev/null; then
    echo "✅ Poetry is installed: $(poetry --version)"
else
    echo "❌ Poetry is not installed"
    exit 1
fi

# Check if we're in a Poetry project
if [ -f "pyproject.toml" ]; then
    echo "✅ Found pyproject.toml in current directory"
    
    # Show current Poetry environment
    echo "📦 Current Poetry environment:"
    poetry env info --path 2>/dev/null || echo "No poetry environment found"
    
    # Show Poetry environment name
    echo "🏷️  Poetry environment name:"
    poetry env info --path 2>/dev/null | xargs basename
else
    echo "ℹ️  Not in a Poetry project directory"
    echo "💡 To test, navigate to a Poetry project or create one with:"
    echo "   poetry new test-project && cd test-project"
fi

echo ""
echo "🎨 Your prompt should now show Poetry environments with the 🎭 icon"
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' in a new zsh session"
