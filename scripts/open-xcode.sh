#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_DIR="$ROOT_DIR/templates/macos-desktop-pet"

if command -v xed >/dev/null 2>&1; then
  xed "$PACKAGE_DIR"
else
  open "$PACKAGE_DIR/Package.swift"
fi
