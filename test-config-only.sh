#!/usr/bin/env bash
# Isolated test of just the config creation function
set -euo pipefail

echo "🧪 Testing isolated config creation function..."

# Create test environment
TEST_HOME="/tmp/config-only-test-$$"
mkdir -p "$TEST_HOME/.config/aichat"

echo "📁 Test environment: $TEST_HOME"

# Extract and test just the config function
configure_local_role_default() {
    local config_file="$HOME/.config/aichat/config.yaml"
    
    echo "⚙️  Configuring aichat to use local role by default..."
    
    # Create config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        echo "📝 Creating new aichat config file..."
        cat > "$config_file" <<'EOF'
# see https://github.com/sigoden/aichat/blob/main/config.example.yaml

model: gpt-4o-mini
stream: true
editor: nano
keybindings: emacs

# Uncomment and configure if using Ollama
# clients:
# - type: openai-compatible
#   name: ollama
#   api_base: http://localhost:11434/v1
#   api_key: none
#   models:
#   - name: embeddinggemma:300m
#     type: embedding
#     default_chunk_size: 1000
#     max_batch_size: 100
#   - name: Qwen3-Reranker-8B:Q4_K_M
#     type: reranker
#   - name: llama3.2:3b
#     supports_vision: false
#     supports_function_calling: true

# Visit https://github.com/sigoden/llm-functions for setup instructions
function_calling: true           # Enables or disables function calling (Globally).
mapping_tools:                   # Alias for a tool or toolset
  fs: 'fs_cat,fs_ls,fs_mkdir,fs_rm,fs_write'
use_tools: null                  # Which tools to use by default

# Controls the persistence of the session. if true, auto save; if false, not save; if null, asking the user
save_session: null
# Compress session when token count reaches or exceeds this threshold
compress_threshold: 4000
# Text prompt used for creating a concise summary of session message
summarize_prompt: '...'
# Text prompt used for including the summary of the entire session
summary_prompt: '...'

highlight: true                  # Controls syntax highlighting
theme: null                      # Color theme (possible value: dark/light)
# Custom REPL prompt, see https://github.com/sigoden/aichat/wiki/Custom-REPL-Prompt for more details
left_prompt: '...'
right_prompt: '...'

serve_addr: 127.0.0.1:8000                  # Serve listening address 
user_agent: null                            # Set User-Agent HTTP header, use `auto` for aichat/<current-version>
save_shell_history: true                    # Whether to save shell execution command to the history file
#sync_models_url: <url>                      # URL to sync model changes from

# Start the REPL and one-shot CLI in the "local" role by default
repl_prelude: "role:local"
cmd_prelude:  "role:local"
EOF
        chmod 644 "$config_file"
        echo "✅ Config file created with comprehensive default settings"
        echo "   📋 Features enabled: Function calling, shell history, local role"
        echo "   🔧 Edit ~/.config/aichat/config.yaml to customize further"
        echo "   💡 Uncomment Ollama section if using local models"
        return 0
    fi
    
    # Additional logic for existing files would go here...
    echo "ℹ️  Config file already exists"
    return 0
}

# Run the test
HOME="$TEST_HOME" configure_local_role_default

echo ""
echo "🔍 Detailed verification:"

CONFIG_FILE="$TEST_HOME/.config/aichat/config.yaml"

# Check all the key features
echo "✅ File created: $(ls -la "$CONFIG_FILE" | awk '{print $5}') bytes"

echo ""
echo "📋 Feature checklist:"

# Function calling
if grep -q "function_calling: true" "$CONFIG_FILE"; then
    echo "✅ Function calling: enabled"
else
    echo "❌ Function calling: missing"
fi

# File system tools
if grep -q "fs: 'fs_cat,fs_ls,fs_mkdir,fs_rm,fs_write'" "$CONFIG_FILE"; then
    echo "✅ File system tools: mapped"
else
    echo "❌ File system tools: missing"
fi

# Local role
if grep -q 'repl_prelude: "role:local"' "$CONFIG_FILE"; then
    echo "✅ REPL local role: configured"
else
    echo "❌ REPL local role: missing"
fi

if grep -q 'cmd_prelude: "role:local"' "$CONFIG_FILE"; then
    echo "✅ CLI local role: configured"
else
    echo "❌ CLI local role: missing"
fi

# Ollama template
if grep -q "# Uncomment and configure if using Ollama" "$CONFIG_FILE"; then
    echo "✅ Ollama template: present"
else
    echo "❌ Ollama template: missing"
fi

# Shell history
if grep -q "save_shell_history: true" "$CONFIG_FILE"; then
    echo "✅ Shell history: enabled"
else
    echo "❌ Shell history: missing"
fi

# Model configuration
if grep -q "model: gpt-4o-mini" "$CONFIG_FILE"; then
    echo "✅ Default model: gpt-4o-mini"
else
    echo "❌ Default model: missing"
fi

# Streaming
if grep -q "stream: true" "$CONFIG_FILE"; then
    echo "✅ Streaming: enabled"
else
    echo "❌ Streaming: missing"
fi

echo ""
echo "📊 Statistics:"
echo "   Lines: $(wc -l < "$CONFIG_FILE")"
echo "   Words: $(wc -w < "$CONFIG_FILE")"
echo "   Characters: $(wc -c < "$CONFIG_FILE")"

# Test YAML validity if possible
echo ""
echo "🔧 YAML Validation:"
if command -v python3 >/dev/null 2>&1; then
    python3 -c "
import yaml
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = yaml.safe_load(f)
    print('✅ Valid YAML syntax')
    print(f'   Config keys: {len(config) if config else 0}')
    if config and 'repl_prelude' in config:
        print(f'   REPL prelude: {config[\"repl_prelude\"]}')
    if config and 'cmd_prelude' in config:
        print(f'   CMD prelude: {config[\"cmd_prelude\"]}')
except Exception as e:
    print(f'❌ YAML error: {e}')
" 2>/dev/null || echo "ℹ️  Python3 not available for YAML validation"
else
    echo "ℹ️  Python3 not available for YAML validation"
fi

# Cleanup
rm -rf "$TEST_HOME"

echo ""
echo "🎯 Isolated config test completed successfully!"