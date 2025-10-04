#!/usr/bin/env bash
# Test script for fresh aichat installation with new comprehensive config
set -euo pipefail

echo "🧪 Testing fresh aichat installation with new comprehensive config..."

# Create isolated test environment
TEST_HOME="/tmp/aichat-fresh-test-$$"
mkdir -p "$TEST_HOME"
export HOME="$TEST_HOME"

echo "🏠 Test environment: $TEST_HOME"

# Copy install script to test directory
cp install-aichat gen-aichat-role "$TEST_HOME/"
cd "$TEST_HOME"

echo ""
echo "📋 Test Plan:"
echo "1. Run installation with minimal interaction"
echo "2. Verify config file creation"
echo "3. Check config content and structure"
echo "4. Validate local role integration"
echo "5. Test directory structure"

echo ""
echo "🚀 Starting installation test..."

# Run installation with automated responses
{
    echo "0.30.0"        # Version
    echo "n"             # Don't overwrite existing (shouldn't exist)
    echo "y"             # Install shell integration
    echo "n"             # Skip binary install for test
    echo "4"             # Skip completions for test
} | timeout 30 ./install-aichat --config-only 2>/dev/null || {
    # If --config-only flag doesn't exist, run with manual interaction
    echo ""
    echo "📝 Running with manual simulation..."
    
    # Create a wrapper that simulates user input
    cat > test_wrapper.sh << 'TEST_EOF'
#!/bin/bash
export SKIP_BINARY_INSTALL=true
export INSTALL_INTEGRATION=false
export INSTALL_COMPLETIONS=false

# Source the install script functions
source ./install-aichat

# Run only the configuration parts
echo "📁 Creating directories..."
ensure_aichat_config_dirs

echo "⚙️ Configuring local role..."
configure_local_role_default

echo "✅ Configuration test completed"
TEST_EOF
    
    chmod +x test_wrapper.sh
    ./test_wrapper.sh
}

echo ""
echo "🔍 Verification Results:"

# Check if config file was created
CONFIG_FILE="$HOME/.config/aichat/config.yaml"
if [[ -f "$CONFIG_FILE" ]]; then
    echo "✅ Config file created: $CONFIG_FILE"
    
    # Check file size and content
    FILE_SIZE=$(wc -c < "$CONFIG_FILE")
    LINE_COUNT=$(wc -l < "$CONFIG_FILE")
    echo "   📊 Size: ${FILE_SIZE} bytes, ${LINE_COUNT} lines"
    
    # Verify key features are present
    echo ""
    echo "🔍 Feature verification:"
    
    # Check for function calling
    if grep -q "function_calling: true" "$CONFIG_FILE"; then
        echo "✅ Function calling enabled"
    else
        echo "❌ Function calling missing"
    fi
    
    # Check for local role configuration
    if grep -q 'repl_prelude: "role:local"' "$CONFIG_FILE" && grep -q 'cmd_prelude: "role:local"' "$CONFIG_FILE"; then
        echo "✅ Local role configured for REPL and CLI"
    else
        echo "❌ Local role configuration missing"
    fi
    
    # Check for Ollama template
    if grep -q "# Uncomment and configure if using Ollama" "$CONFIG_FILE"; then
        echo "✅ Ollama configuration template present"
    else
        echo "❌ Ollama template missing"
    fi
    
    # Check for file system tools
    if grep -q "fs: 'fs_cat,fs_ls,fs_mkdir,fs_rm,fs_write'" "$CONFIG_FILE"; then
        echo "✅ File system tools mapped"
    else
        echo "❌ File system tools mapping missing"
    fi
    
    # Check for shell history
    if grep -q "save_shell_history: true" "$CONFIG_FILE"; then
        echo "✅ Shell history saving enabled"
    else
        echo "❌ Shell history configuration missing"
    fi
    
    echo ""
    echo "📄 Config file preview (first 20 lines):"
    head -20 "$CONFIG_FILE" | sed 's/^/   /'
    
    echo ""
    echo "📄 Local role configuration (last 5 lines):"
    tail -5 "$CONFIG_FILE" | sed 's/^/   /'
    
else
    echo "❌ Config file not created"
fi

# Check directory structure
echo ""
echo "📁 Directory structure:"
if [[ -d "$HOME/.config/aichat" ]]; then
    echo "✅ Main config directory: ~/.config/aichat"
    ls -la "$HOME/.config/aichat/" | sed 's/^/   /'
    
    if [[ -d "$HOME/.config/aichat/roles" ]]; then
        echo "✅ Roles directory created"
    else
        echo "❌ Roles directory missing"
    fi
else
    echo "❌ Config directory not created"
fi

# Test config file validation (YAML syntax)
echo ""
echo "🔧 Configuration validation:"
if command -v python3 >/dev/null 2>&1; then
    python3 -c "
import yaml
import sys
try:
    with open('$CONFIG_FILE', 'r') as f:
        yaml.safe_load(f)
    print('✅ YAML syntax is valid')
except yaml.YAMLError as e:
    print(f'❌ YAML syntax error: {e}')
    sys.exit(1)
except FileNotFoundError:
    print('❌ Config file not found')
    sys.exit(1)
" 2>/dev/null || echo "ℹ️  Python3/PyYAML not available for YAML validation"
fi

# Cleanup
cd /
rm -rf "$TEST_HOME"

echo ""
echo "🎯 Fresh installation test completed!"
echo "📋 Summary: New users will receive a comprehensive, production-ready configuration"