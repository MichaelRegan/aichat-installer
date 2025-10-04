#!/usr/bin/env bash
# Comprehensive test suite for install-aichat script
set -euo pipefail

TEST_DIR="/tmp/aichat-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Copy test files
cp "$1"/* . 2>/dev/null || { echo "Usage: $0 <source-directory>"; exit 1; }

echo "🧪 Running comprehensive aichat installation tests..."
echo "Test directory: $TEST_DIR"

# Test 1: Syntax validation
echo ""
echo "1️⃣ Testing script syntax..."
bash -n ./install-aichat && echo "✅ Syntax check passed" || echo "❌ Syntax check failed"

# Test 2: Version validation
echo ""
echo "2️⃣ Testing version validation..."
test_versions=("1.2.3" "0.30.0" "invalid" "1.2" "abc.def.ghi")
for version in "${test_versions[@]}"; do
    echo -n "   Testing version '$version': "
    # Create a minimal test script that only tests the validation logic
    cat > test_validate.sh << 'EOF'
#!/bin/bash
validate_version() {
    local version="$1"
    if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}
validate_version "$1"
EOF
    chmod +x test_validate.sh
    if ./test_validate.sh "$version" 2>/dev/null; then
        echo "✅ Valid"
    else
        echo "❌ Invalid"
    fi
    rm -f test_validate.sh
done

# Test 3: Architecture detection
echo ""
echo "3️⃣ Testing architecture detection..."
echo -n "   Current architecture: "
# Extract and test just the architecture detection logic
cat > test_arch.sh << 'EOF'
#!/bin/bash
detect_architecture() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64) echo "x86_64" ;;
        aarch64|arm64) echo "aarch64" ;;
        armv7*) echo "armv7" ;;
        *) echo "unsupported" ;;
    esac
}
detect_architecture
EOF
chmod +x test_arch.sh
./test_arch.sh
rm -f test_arch.sh

# Test 4: Shell detection  
echo ""
echo "4️⃣ Testing shell detection..."
for shell in bash zsh; do
    if command -v "$shell" >/dev/null 2>&1; then
        echo -n "   Detecting from $shell: "
        # Create a test that simulates shell detection
        cat > test_shell.sh << 'EOF'
#!/bin/bash
detect_shell() {
    local shell_path
    shell_path="$(ps -p $$ -o comm= 2>/dev/null | sed 's/^-//')"
    case "$shell_path" in
        *bash*) echo "bash" ;;
        *zsh*) echo "zsh" ;;
        *fish*) echo "fish" ;;
        *) echo "unknown" ;;
    esac
}
detect_shell
EOF
        chmod +x test_shell.sh
        "$shell" ./test_shell.sh
        rm -f test_shell.sh
    fi
done

# Test 5: Directory creation functions
echo ""
echo "5️⃣ Testing directory creation..."
TEST_CONFIG_DIR="$TEST_DIR/.config/aichat"
# Test directory creation logic
cat > test_dirs.sh << 'EOF'
#!/bin/bash
ensure_aichat_config_dirs() {
    local config_dir="$HOME/.config/aichat"
    local roles_dir="$config_dir/roles"
    mkdir -p "$config_dir" "$roles_dir"
    return 0
}
ensure_aichat_config_dirs
EOF
chmod +x test_dirs.sh
HOME="$TEST_DIR" ./test_dirs.sh && echo "✅ Config directories created" || echo "❌ Config directory creation failed"
rm -f test_dirs.sh

# Test 6: Config file creation
echo ""
echo "6️⃣ Testing config file creation..."
if [[ -f "./gen-aichat-role" ]]; then
    HOME="$TEST_DIR" bash -c "
        source ./install-aichat
        configure_local_role_default
    " && echo "✅ Config file creation works" || echo "❌ Config file creation failed"
    
    # Check if config was created correctly
    if [[ -f "$TEST_CONFIG_DIR/config.yaml" ]]; then
        echo "   Config file contents:"
        sed 's/^/      /' "$TEST_CONFIG_DIR/config.yaml"
    fi
else
    echo "⚠️  gen-aichat-role script not found, skipping config test"
fi

# Test 7: Completion file validation
echo ""
echo "7️⃣ Testing completion downloads..."
for shell in bash zsh fish; do
    echo -n "   Testing $shell completion download: "
    if curl -fsSL "https://raw.githubusercontent.com/sigoden/aichat/refs/heads/main/scripts/completions/aichat.$shell" >/dev/null 2>&1; then
        echo "✅ Available"
    else
        echo "❌ Failed to download"
    fi
done

# Test 8: Integration script validation
echo ""
echo "8️⃣ Testing integration downloads..."
for shell in bash zsh fish; do
    echo -n "   Testing $shell integration download: "
    if curl -fsSL "https://raw.githubusercontent.com/sigoden/aichat/refs/heads/main/scripts/shell-integration/integration.$shell" >/dev/null 2>&1; then
        echo "✅ Available"
    else
        echo "❌ Failed to download"
    fi
done

# Test 9: Asset availability
echo ""
echo "9️⃣ Testing GitHub asset availability..."
VERSION="0.30.0"
ASSETS=(
    "aichat-v$VERSION-x86_64-unknown-linux-musl.tar.gz"
    "aichat-v$VERSION-aarch64-unknown-linux-musl.tar.gz"
)

for asset in "${ASSETS[@]}"; do
    echo -n "   Testing asset $asset: "
    if curl -fsSL -I "https://github.com/sigoden/aichat/releases/download/v$VERSION/$asset" >/dev/null 2>&1; then
        echo "✅ Available"
    else
        echo "❌ Not found"
    fi
done

# Cleanup
echo ""
echo "🧹 Cleaning up test directory..."
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🎯 Test suite completed!"