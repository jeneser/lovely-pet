#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="Lovely Pet Demo"
EXECUTABLE="LovelyPetApp"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
ZIP_PATH="$DIST_DIR/Lovely-Pet-Demo.zip"
PLIST_NAME="Info.plist"
PET_SOURCE="$ROOT_DIR/Sources/LovelyPetApp/Resources/pets"
cd "$ROOT_DIR"
swift build -c release
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$ROOT_DIR/.build/release/$EXECUTABLE" "$APP_DIR/Contents/MacOS/$EXECUTABLE"
cp "$ROOT_DIR/AppBundle/$PLIST_NAME" "$APP_DIR/Contents/$PLIST_NAME"
cp -a "$PET_SOURCE" "$APP_DIR/Contents/Resources/pets"
chmod +x "$APP_DIR/Contents/MacOS/$EXECUTABLE"
if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - "$APP_DIR" >/dev/null 2>&1 || true
fi
if command -v ditto >/dev/null 2>&1; then
  ditto -c -k --keepParent "$APP_DIR" "$ZIP_PATH"
else
  cd "$DIST_DIR" && zip -qr "Lovely-Pet-Demo.zip" "$APP_NAME.app"
fi
echo "Built: $APP_DIR"
echo "Archive: $ZIP_PATH"
