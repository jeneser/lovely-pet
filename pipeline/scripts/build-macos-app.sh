#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/templates/macos-desktop-pet"
MANIFEST="$TEMPLATE_DIR/Resources/pets/default/pet.json"

python3 "$ROOT_DIR/pipeline/scripts/validate-pet-manifest.py" "$MANIFEST"

pushd "$TEMPLATE_DIR" >/dev/null
swift build -c release
popd >/dev/null

echo "Template build complete. Production packaging should add .app bundling, codesign, notarization, zip, and upload."
