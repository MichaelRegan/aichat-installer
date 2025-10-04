#!/usr/bin/env bash
# aichat Installation Verification Script
# Run this after installing aichat to verify everything is working correctly

set -euo pipefail

echo "🔍 aichat Installation Verification"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
total_checks=0

check() {
    local description="$1"
    local command="$2"
    
    ((total_checks++))
    echo -n "Checking $description... "
    
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((success_count++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        return 1
    fi
}

check_with_output() {
    local description="$1"
    local command="$2"
    
    ((total_checks++))
    echo -n "Checking $description... "
    
    local output
    if output=$(eval "$command" 2>&1); then
        echo -e "${GREEN}✅ PASS${NC}"
        echo "   → $output"
        ((success_count++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        echo "   → $output"
        return 1
    fi
}

echo ""
echo "1️⃣ Binary Installation"
echo "====================="

check "aichat binary exists" "command -v aichat"
check_with_output "aichat version" "aichat --version"
check "aichat executable permissions" "test -x \$(command -v aichat)"

# Check for wrapper
if [[ -f "/usr/local/bin/aichat.real" ]]; then
    echo -e "   ${GREEN}ℹ️  Wrapper system detected${NC}"
    check "gen-aichat-role script" "command -v gen-aichat-role"
fi

echo ""
echo "2️⃣ Configuration Files"
echo "====================="

check "config directory exists" "test -d ~/.config/aichat"
check "config file exists" "test -f ~/.config/aichat/config.yaml"
check "roles directory exists" "test -d ~/.config/aichat/roles"

if [[ -f ~/.config/aichat/config.yaml ]]; then
    echo -n "Checking config file size... "
    local config_size=$(wc -c < ~/.config/aichat/config.yaml)
    if [[ $config_size -gt 1000 ]]; then
        echo -e "${GREEN}✅ PASS${NC} (${config_size} bytes - comprehensive config)"
        ((success_count++))
    else
        echo -e "${YELLOW}⚠️  MINIMAL${NC} (${config_size} bytes - basic config)"
    fi
    ((total_checks++))
fi

echo ""
echo "3️⃣ Configuration Features"
echo "========================"

if [[ -f ~/.config/aichat/config.yaml ]]; then
    check "function calling enabled" "grep -q 'function_calling: true' ~/.config/aichat/config.yaml"
    check "local role configured" "grep -q 'role:local' ~/.config/aichat/config.yaml"
    check "file system tools mapped" "grep -q 'fs_cat,fs_ls' ~/.config/aichat/config.yaml"
    check "shell history enabled" "grep -q 'save_shell_history: true' ~/.config/aichat/config.yaml"
    check "Ollama template present" "grep -q 'Ollama' ~/.config/aichat/config.yaml"
fi

echo ""
echo "4️⃣ Shell Integration"
echo "==================="

# Check for shell integration in common shells
for shell in bash zsh fish; do
    if command -v "$shell" >/dev/null 2>&1; then
        case "$shell" in
            bash)
                check "$shell integration in ~/.bashrc" "grep -q '_aichat_bash\|aichat' ~/.bashrc 2>/dev/null"
                ;;
            zsh)
                check "$shell integration in ~/.zshrc" "grep -q '_aichat_zsh\|aichat' ~/.zshrc 2>/dev/null"
                ;;
            fish)
                check "$shell integration in config.fish" "test -f ~/.config/fish/config.fish && grep -q 'aichat' ~/.config/fish/config.fish"
                ;;
        esac
    fi
done

echo ""
echo "5️⃣ Tab Completions"
echo "=================="

# Check completion files
completion_paths=(
    "/usr/share/bash-completion/completions/aichat"
    "/usr/share/zsh/vendor-completions.d/_aichat"
    "/usr/share/zsh/site-functions/_aichat"
    "/usr/share/fish/vendor_completions.d/aichat.fish"
)

for path in "${completion_paths[@]}"; do
    if [[ -f "$path" ]]; then
        shell_name=$(basename "$path" | sed 's/.*\.//' | sed 's/_aichat/zsh/' | sed 's/aichat/bash/')
        echo -e "   ${GREEN}✅${NC} $shell_name completion found: $path"
        ((success_count++))
    fi
    ((total_checks++))
done

echo ""
echo "6️⃣ System Context"
echo "================="

if [[ -f ~/.config/aichat/roles/local.md ]]; then
    check "local role file exists" "test -f ~/.config/aichat/roles/local.md"
    
    local role_size=$(wc -c < ~/.config/aichat/roles/local.md)
    echo -n "Checking local role content... "
    if [[ $role_size -gt 100 ]]; then
        echo -e "${GREEN}✅ PASS${NC} (${role_size} bytes)"
        ((success_count++))
    else
        echo -e "${YELLOW}⚠️  MINIMAL${NC} (${role_size} bytes)"
    fi
    ((total_checks++))
else
    echo -e "   ${YELLOW}ℹ️  Local role not found - run 'gen-aichat-role' to create${NC}"
fi

echo ""
echo "7️⃣ Functional Tests"
echo "=================="

# Test basic functionality
check "aichat help command" "aichat --help | head -1"
check "aichat info command" "aichat --info | head -1"

# Test config validation
if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" 2>/dev/null; then
    check "YAML config syntax" "python3 -c 'import yaml; yaml.safe_load(open(\"$HOME/.config/aichat/config.yaml\"))'"
fi

echo ""
echo "📊 Verification Summary"
echo "======================"

local pass_rate=$((success_count * 100 / total_checks))

echo "Tests passed: $success_count/$total_checks (${pass_rate}%)"

if [[ $pass_rate -ge 90 ]]; then
    echo -e "${GREEN}🎉 Excellent! Your aichat installation is comprehensive and fully functional.${NC}"
elif [[ $pass_rate -ge 70 ]]; then
    echo -e "${YELLOW}👍 Good! Your aichat installation is mostly complete with minor issues.${NC}"
else
    echo -e "${RED}⚠️  Issues detected. Your aichat installation needs attention.${NC}"
fi

echo ""
echo "🚀 Next Steps"
echo "============"

if [[ $pass_rate -ge 90 ]]; then
    echo "✨ Try these commands to get started:"
    echo "   aichat                              # Start interactive REPL"
    echo "   aichat 'Tell me about this system'  # One-shot with system context"
    echo "   [Type a command] + Alt+E            # Enhance any command with AI"
elif [[ -f ~/.config/aichat/config.yaml ]] && ! grep -q "role:local" ~/.config/aichat/config.yaml; then
    echo "🔧 Consider running the install script again to get the comprehensive config:"
    echo "   ./install-aichat"
elif [[ ! -f ~/.config/aichat/roles/local.md ]]; then
    echo "🎯 Generate your system context role:"
    echo "   gen-aichat-role"
fi

if [[ ! $(grep -l "_aichat\|aichat" ~/.bashrc ~/.zshrc 2>/dev/null) ]]; then
    echo "🐚 To enable shell integration, restart your shell or run:"
    echo "   source ~/.bashrc    # for bash"
    echo "   source ~/.zshrc     # for zsh"
fi

echo ""
echo "📚 Documentation: README.md"
echo "🆘 Quick help: QUICK_REFERENCE.md"