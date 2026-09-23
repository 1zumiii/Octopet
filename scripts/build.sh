#!/bin/bash
# Build a universal (Apple Silicon + Intel) Octopet.app and a release zip.
# Usage: scripts/build.sh [version]
set -euo pipefail

VERSION="${1:-1.0.0}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
APP="$BUILD/Octopet.app"
SOURCES=("$ROOT"/Sources/Octopet/*.swift)

rm -rf "$BUILD"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

echo "▸ Compiling"
for arch in arm64 x86_64; do
    swiftc -O -target "$arch-apple-macos11.0" "${SOURCES[@]}" -o "$BUILD/Octopet-$arch"
done
lipo -create "$BUILD/Octopet-arm64" "$BUILD/Octopet-x86_64" -output "$APP/Contents/MacOS/Octopet"
rm "$BUILD"/Octopet-arm64 "$BUILD"/Octopet-x86_64

echo "▸ Icon"
ICONSET="$BUILD/AppIcon.iconset"
mkdir -p "$ICONSET"
"$APP/Contents/MacOS/Octopet" --icon "$BUILD/icon.png" 1024
for s in 16 32 128 256 512; do
    sips -z $s $s "$BUILD/icon.png" --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
    sips -z $((s * 2)) $((s * 2)) "$BUILD/icon.png" --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf "$ICONSET"

echo "▸ Info.plist"
cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Octopet</string>
    <key>CFBundleDisplayName</key><string>Octopet</string>
    <key>CFBundleIdentifier</key><string>io.github.1zumiii.octopet</string>
    <key>CFBundleExecutable</key><string>Octopet</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>$VERSION</string>
    <key>CFBundleVersion</key><string>$VERSION</string>
    <key>LSMinimumSystemVersion</key><string>11.0</string>
    <key>LSUIElement</key><true/>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

echo "▸ Ad-hoc signing"
codesign --force --deep --sign - "$APP"

echo "▸ Zip"
(cd "$BUILD" && ditto -c -k --keepParent Octopet.app "Octopet-v$VERSION.zip")
echo "✓ $BUILD/Octopet-v$VERSION.zip"
