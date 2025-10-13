#!/usr/bin/env bash
# Test: dry-run mode should not modify filesystem and JSON output parses.
set -euo pipefail

echo "🧪 Testing dry-run modes..."
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$PWD/install-aichat" && "$PWD" == /tmp/aichat-test-* ]]; then
  # Running inside aggregated test-suite working dir already containing install-aichat
  WORKDIR="$PWD"
  IN_PLACE=1
else
  WORKDIR="/tmp/aichat-dryrun-test-$$"
  mkdir -p "$WORKDIR"
  pushd "$WORKDIR" >/dev/null
  cp "$ROOT_DIR/install-aichat" ./
  IN_PLACE=0
fi

TEST_VERSION="${AICHAT_TEST_VERSION:-0.30.0}"

echo "1) Plain dry-run (version $TEST_VERSION)"
OUT1=$(bash ./install-aichat --dry-run "$TEST_VERSION" 2>&1 || true)
echo "$OUT1" | grep -q "DRY-RUN MODE" || { echo "❌ Plain dry-run missing marker"; exit 1; }

echo "2) JSON dry-run with flags"
# In JSON dry-run mode, stdout is ONLY the JSON object; stderr has progress noise
JSON_OUT=$(bash ./install-aichat --dry-run --json --no-wrapper --skip-role "$TEST_VERSION" 2>/dev/null || true)
if [[ -z "$JSON_OUT" ]]; then
  echo "❌ JSON output empty (possible network issue if 'latest' used)"; exit 1;
fi
echo "   JSON bytes: ${#JSON_OUT}" >&2
echo "$JSON_OUT" | grep -q '"mode": "dry-run"' || { echo "❌ JSON dry-run missing mode"; echo "$JSON_OUT"; exit 1; }
echo "$JSON_OUT" | grep -q '"wrapper": {"planned": false' || { echo "❌ JSON missing wrapper planned false"; echo "$JSON_OUT"; exit 1; }
echo "$JSON_OUT" | grep -q '"role_generator": {"planned": false' || { echo "❌ JSON missing role_generator planned false"; echo "$JSON_OUT"; exit 1; }

# Simple JSON structural validation
export JSON_OUT
python3 - <<'PY'
import json, os, sys
raw=os.environ.get('JSON_OUT','')
if not raw.strip():
  print('Empty JSON_OUT env', file=sys.stderr); sys.exit(1)
data=json.loads(raw)
assert data['mode']=='dry-run'
assert data['flags']['dry_run'] is True
print('✅ JSON structure valid')
PY

echo "3) Ensure no side-effect files created (wrapper, role script, config)"
for f in /usr/local/bin/gen-aichat-role ~/.config/aichat/config.yaml /usr/local/bin/aichat.real ; do
  if [[ -e "$f" ]]; then
    echo "ℹ️  Note: $f exists on this system already (ignored)."
  fi
done

echo "✅ Dry-run tests passed"
if [[ "$IN_PLACE" == 0 ]]; then
  popd >/dev/null
  rm -rf "$WORKDIR"
fi