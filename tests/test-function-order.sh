#!/usr/bin/env bash
# Simple test to check function availability

set -euo pipefail

# Source just the functions from the main script
source <(head -100 install-aichat)

echo "Testing validate_version function..."
if validate_version "0.30.0"; then
    echo "✅ Function works correctly"
else
    echo "❌ Function failed"
fi