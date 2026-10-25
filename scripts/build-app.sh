#!/usr/bin/env bash
# Builds Kawa.app into ./build. Pass --universal to include x86_64.
set -euo pipefail

cd "$(dirname "$0")/.."

ARCH_FLAGS=(--arch arm64)
if [[ "${1:-}" == "--universal" ]]; then
  ARCH_FLAGS+=(--arch x86_64)
fi

swift build -c release "${ARCH_FLAGS[@]}"
BIN_DIR="$(swift build -c release "${ARCH_FLAGS[@]}" --show-bin-path)"

APP=build/Kawa.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp "$BIN_DIR/Kawa" "$APP/Contents/MacOS/Kawa"
cp Resources/Info.plist "$APP/Contents/Info.plist"
cp Resources/AppIcon.icns Resources/StatusItemIcon.png Resources/StatusItemIcon@2x.png "$APP/Contents/Resources/"

# KeyboardShortcuts ships its localizations as a SwiftPM resource bundle.
for bundle in "$BIN_DIR"/*.bundle; do
  [[ -e "$bundle" ]] && cp -R "$bundle" "$APP/Contents/Resources/"
done

codesign --force --deep --options runtime --sign "${CODESIGN_IDENTITY:--}" "$APP"

echo "Built $APP ($(lipo -archs "$APP/Contents/MacOS/Kawa"))"
