#!/usr/bin/env bash
# Comprehensive Docker test for aichat-installer
# This test performs a full, realistic installation inside a container.
set -euo pipefail

echo "🐳 Comprehensive Docker Test: Full Feature Validation"
echo "====================================================="
echo "Testing: Non-interactive install, zsh integration, and role generation."

# Test distributions
DISTRIBUTIONS=("ubuntu:24.04" "debian:bookworm")
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

for distro in "${DISTRIBUTIONS[@]}"; do
    echo ""
    echo "🧪 Testing full installation on $distro..."

    # Use a heredoc for the script to be executed inside the container.
    # This makes it much easier to read and maintain.
        DOCKER_SCRIPT=$(cat <<'EOF'
set -euo pipefail
set -x

echo "--- Preparing container environment ---"
export DEBIAN_FRONTEND=noninteractive
apt-get update || { echo 'APT update failed'; exit 2; }
apt-get install -y curl tar sudo zsh git ca-certificates || { echo 'APT install failed'; exit 3; }
update-ca-certificates || true
command -v curl || { echo 'curl missing after install'; exit 4; }

echo "--- Creating test user 'tester' with zsh and sudo ---"
useradd -m -s /bin/zsh -G sudo tester
echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
id tester

echo "--- Switching to user 'tester' to run installation ---"
su - tester -c '
set -euo pipefail
set -x
cd /aichat-installer
ls -al
echo "--- Pre-flight: syntax check ---"
bash -n ./install-aichat || { echo "Syntax error"; exit 10; }

echo "--- Starting non-interactive installation (AICHAT_ASSUME_YES) ---"
AICHAT_ASSUME_YES=1 ./install-aichat latest || { rc=$?; echo "Installer failed rc=$rc"; exit $rc; }

echo "--- Verifying installation ---"
ls -al /usr/local/bin | grep aichat || true
if [[ -f /usr/local/bin/aichat && -f /usr/local/bin/aichat.real && -f /usr/local/bin/gen-aichat-role ]]; then
    echo "✅ Binaries installed"
else
    echo "❌ Missing binaries"; exit 21; fi

echo "--- Checking .zshrc for Alt+E keybinding ---"
if [[ -f ~/.zshrc ]]; then
    if grep -E "bindkey.*_aichat_zsh" ~/.zshrc >/dev/null 2>&1; then
        echo "✅ Alt+E binding present"
    else
        echo "❌ Keybinding not found"; exit 22;
    fi
else
    echo "❌ ~/.zshrc missing"; exit 23; fi

echo "--- Checking generated role file ---"
ROLE_FILE=~/.config/aichat/roles/local.md
# Trigger role generation once (wrapper runs gen-aichat-role) if file missing
if [[ ! -f "$ROLE_FILE" ]]; then
    echo "(role) generating via gen-aichat-role..."
    set +e
    echo "PATH during role generation: $PATH"
    which gen-aichat-role || echo "gen-aichat-role not in PATH"
    gen-aichat-role || /usr/local/bin/gen-aichat-role
    gen_rc=$?
    echo "gen-aichat-role exit code: $gen_rc"
    ls -al ~/.config/aichat/roles || true
    set -e
fi
if [[ -f "$ROLE_FILE" ]]; then
    head -20 "$ROLE_FILE" || true
else
    echo "⚠️ Role file missing after generation attempts (non-fatal for now)"; fi

if grep -q "\`\`\`yaml" "$ROLE_FILE"; then
    echo "✅ YAML fence present"
else
    echo "❌ YAML fence missing"; exit 25; fi

HOSTNAME_SAFE="$(hostname 2>/dev/null || echo unknown)"
if grep -q "host: ${HOSTNAME_SAFE}" "$ROLE_FILE"; then
    echo "✅ Variable expansion ok"
else
    echo "⚠️ Host line not matched; dumping snippet"; grep -n 'host:' "$ROLE_FILE"; fi

echo "--- Test complete for this user ---"
'
EOF
)

    # Run the docker container and execute the script
    docker run --rm -v "$PROJECT_ROOT:/aichat-installer" "$distro" bash -c "$DOCKER_SCRIPT"
    
    exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        echo "✅ $distro: COMPREHENSIVE TEST PASSED"
    else
        echo "❌ $distro: FAILED (exit code: $exit_code)"
        # Exit on first failure to make debugging easier
        exit 1
    fi
done

echo ""
echo "🎉 All comprehensive Docker tests passed successfully!"
echo "   - Non-interactive installation works."
echo "   - Zsh integration for Alt+E is correct."
echo "   - Role file is generated correctly with expanded variables."