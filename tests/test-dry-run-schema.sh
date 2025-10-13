#!/usr/bin/env bash
# Validates the JSON schema shape of dry-run --json output.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$PWD/install-aichat" && "$PWD" == /tmp/aichat-test-* ]]; then
  TMPDIR="$PWD"
  IN_PLACE=1
else
  TMPDIR="/tmp/aichat-dryrun-schema-$$"
  mkdir -p "$TMPDIR"
  cd "$TMPDIR"
  cp "$ROOT_DIR/install-aichat" ./
  IN_PLACE=0
fi

VERSION="${AICHAT_TEST_VERSION:-0.30.0}"
JSON=$(bash ./install-aichat --dry-run --json --no-wrapper --skip-role "$VERSION" 2>/dev/null)

if [[ -z "$JSON" ]]; then
  echo "❌ Empty JSON output"; exit 1
fi

# Basic required keys
for key in mode target_version architecture download_url binary_target wrapper role_generator shell completions config backups flags; do
  grep -q "\"$key\"" <<<"$JSON" || { echo "❌ Missing key: $key"; echo "$JSON"; exit 1; }
done

echo "$JSON" > schema.json
python3 - <<'PY'
import json, sys
with open('schema.json') as f:
    data=json.load(f)
# Type checks
assert data['mode']=='dry-run'
assert isinstance(data['target_version'], str)
assert data['architecture'].startswith('linux-')
for k in ['download_url','binary_target']:
    assert isinstance(data[k], str)
# Nested objects
for obj in ['wrapper','role_generator']:
    assert 'planned' in data[obj]
    assert isinstance(data[obj]['planned'], bool)
    assert 'skip_reason' in data[obj]
# shell structure
assert 'detected' in data['shell']
# completions array
assert isinstance(data['completions'], list) and data['completions']
# flags booleans
for fk in ['dry_run','json','no_wrapper','skip_role']:
    assert isinstance(data['flags'][fk], bool)
print('✅ Dry-run JSON schema validated')
PY

echo "✅ Schema test passed"
if [[ "$IN_PLACE" == 0 ]]; then
  rm -rf "$TMPDIR"
fi
