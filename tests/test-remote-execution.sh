#!/usr/bin/env bash
# Test the remote curl execution to ensure it works

echo "🧪 Testing remote curl execution simulation..."

# Simulate what curl does - download and pipe to bash
echo "Downloading script content..."
curl -fsSL "https://raw.githubusercontent.com/MichaelRegan/aichat-installer/refs/heads/main/install-aichat" > /tmp/test-install-aichat

echo "Checking syntax of downloaded script..."
if bash -n /tmp/test-install-aichat; then
    echo "✅ Downloaded script syntax is valid"
else
    echo "❌ Downloaded script has syntax errors"
    exit 1
fi

echo "Testing non-interactive execution..."
echo "" | bash /tmp/test-install-aichat 2>&1 | head -5

echo "✅ Remote execution test complete"
rm -f /tmp/test-install-aichat