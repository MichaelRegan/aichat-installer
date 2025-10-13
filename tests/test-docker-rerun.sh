#!/usr/bin/env bash
# Idempotency Test: Verifies that re-running the installer works correctly.
set -euo pipefail
set -x

echo "🐳 Idempotency Test: Re-running the Installer"
echo "================================================"
echo "Testing: Ensures a second run updates files and doesn't break."

DISTROS=("ubuntu:24.04" "debian:bookworm")
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

for DISTRO in "${DISTROS[@]}"; do
echo "🧪 Testing installer re-run on $DISTRO..."

DOCKER_SCRIPT=$(cat <<'EOF'
set -euo pipefail

echo "--- Preparing container environment ---"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl tar sudo zsh git

echo "--- Creating test user 'tester' ---"
useradd -m -s /bin/zsh -G sudo tester
echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "--- Switching to user 'tester' to run installations ---"
cat > /home/tester/idempotency-test.sh <<'INNERSCRIPT'
#!/usr/bin/env bash
set -euo pipefail
set -x
cd /aichat-installer

echo '--- Pass 1: Running first installation ---'
AICHAT_ASSUME_YES=1 ./install-aichat latest
echo 'Pass1 done; listing backups (should be none yet):'
ls -al ~/.config/aichat || true
ls -1 ~/.config/aichat/config.yaml.backup.* 2>/dev/null || echo 'No config backups yet (expected)'
ls -1 ~/.zshrc.backup.* 2>/dev/null || echo 'No zshrc backups yet (expected)'
# Capture the modification time of a key file
initial_mod_time=$(stat -c %Y /usr/local/bin/gen-aichat-role)
# Sleep to ensure the timestamp on the next install will be different
sleep 2

echo '--- Pass 2: Running second installation ---'
AICHAT_ASSUME_YES=1 ./install-aichat latest
echo 'Pass2 done; listing backups:'
ls -1 ~/.config/aichat/config.yaml.backup.* 2>/dev/null || echo 'No config backups found (unexpected)'
ls -1 ~/.zshrc.backup.* 2>/dev/null || echo 'No zshrc backups found (unexpected)'

echo '--- Verifying results of second run ---'

# 1. Check that the script was overwritten
current_mod_time=$(stat -c %Y /usr/local/bin/gen-aichat-role)
if [[ "$current_mod_time" -gt "$initial_mod_time" ]]; then
    echo '✅ gen-aichat-role script was successfully updated (overwritten).'
else
    echo '❌ gen-aichat-role script was not updated on second run!'
    exit 1
fi

# 2. Check for backup files
## With 'set -o pipefail', a failing 'ls' would trigger the fallback and duplicate counts (e.g. '0\n0').
## Temporarily disable pipefail for the counting logic to avoid that duplication.
set +o pipefail
config_backup_count=$(ls -1 ~/.config/aichat/config.yaml.backup.* 2>/dev/null | wc -l)
zshrc_backup_count=$(ls -1 ~/.zshrc.backup.* 2>/dev/null | wc -l)
set -o pipefail

if [[ "$config_backup_count" -ge 1 ]]; then
    echo "✅ Config backup file found (${config_backup_count} found)."
else
    echo "ℹ️  No config backup created (config was already up-to-date; this is acceptable)."
fi

if [[ "$zshrc_backup_count" -ge 1 ]]; then
    echo "✅ .zshrc backup file found (${zshrc_backup_count} found)."
else
    echo '❌ .zshrc backup was not created on re-run!'
    exit 1
fi

# 3. Check that there aren't duplicate entries in .zshrc
integration_block_count=$(grep -c "# aichat shell integration" ~/.zshrc)
if [[ "$integration_block_count" -eq 1 ]]; then
    echo '✅ .zshrc has only one shell integration block.'
else
    echo "❌ .zshrc has ${integration_block_count} integration blocks (should be 1)!"
    exit 1
fi

# 4. Wrapper integrity: ensure wrapper exists, real binary exists, and wrapper references aichat.real
if [[ -x /usr/local/bin/aichat && -x /usr/local/bin/aichat.real ]]; then
    if grep -q "aichat.real" /usr/local/bin/aichat; then
        echo '✅ Wrapper script references aichat.real and both are executable.'
    else
        echo '❌ Wrapper script missing reference to aichat.real'
        exit 1
    fi
else
    echo '❌ Wrapper or real binary missing or not executable'
    exit 1
fi

echo '--- Idempotency test complete ---'
INNERSCRIPT
chown tester:tester /home/tester/idempotency-test.sh
chmod +x /home/tester/idempotency-test.sh
su - tester -c "/home/tester/idempotency-test.sh"
EOF
)

echo "--- Container script (truncated preview) ---"
echo "${DOCKER_SCRIPT}" | head -40
docker run --rm -v "$PROJECT_ROOT:/aichat-installer" "$DISTRO" bash -c "$DOCKER_SCRIPT"

exit_code=$?
if [[ $exit_code -eq 0 ]]; then
    echo "✅ $DISTRO: IDEMPOTENCY TEST PASSED"
else
    echo "❌ $DISTRO: FAILED (exit code: $exit_code)"
    exit 1
fi
done

echo ""
echo "🎉 All idempotency tests passed successfully!"
echo "   - Installer correctly overwrites existing files."
echo "   - .zshrc backup created; config backup only when config modified (optional)."
echo "   - No duplicate entries are added to shell profiles."
