#!/bin/bash
# Render the README preview GIF (needs ffmpeg). Run scripts/build.sh first.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
"$ROOT/build/Octopet.app/Contents/MacOS/Octopet" --preview "$TMP" 10
ffmpeg -loglevel error -y -framerate 30 -i "$TMP/%04d.png" \
    -vf "split[a][b];[a]palettegen=reserve_transparent=1[p];[b][p]paletteuse" \
    -gifflags -offsetting "$ROOT/docs/preview.gif"
rm -rf "$TMP"
echo "✓ docs/preview.gif"
