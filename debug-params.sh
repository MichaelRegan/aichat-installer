#!/usr/bin/env bash
# Debug script to test parameter resolution
set -euo pipefail

echo "=== Debug Parameter Resolution ==="
echo "Arguments: $#"
echo "Arg 1: ${1:-none}"
echo "AICHAT_VERSION: ${AICHAT_VERSION:-not_set}"

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    if [[ -n "${AICHAT_VERSION:-}" ]]; then
        echo "Environment variable found: $AICHAT_VERSION"
        if [[ "${AICHAT_VERSION}" == "latest" ]]; then
            echo "Would fetch latest version"
        else
            echo "Would use version: $AICHAT_VERSION"
        fi
    else
        echo "No environment variable, would auto-detect"
    fi
else
    echo "Arguments provided: $1"
fi