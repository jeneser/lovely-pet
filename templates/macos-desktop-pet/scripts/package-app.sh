#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="Lovely Pet Demo"
EXECUTABLE="LovelyPetApp"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
PLIST_NAME="Info.plist"
cd "$ROOT_DIR"
swift build -c release
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$ROOT_DIR/.build/release/$EXECUTABLE" "$APP_DIR/Contents/MacOS/$EXECUTABLE"
cp "$ROOT_DIR/AppBundle/$PLIST_NAME" "$APP_DIR/Contents/$PLIST_NAME"
echo "Built: $APP_DIR"
