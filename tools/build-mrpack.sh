#!/usr/bin/env bash
# Builds the bootstrap .mrpack that players import into ATLauncher.
# It contains no mods - just the loader version, the packwiz updater, and the
# two jars CurseForge refuses to serve over its API. Everything else is pulled
# from pack.toml on first launch.
set -euo pipefail

PACK_URL="${PACK_URL:-https://raw.githubusercontent.com/UlvFoerlev/occulteyes-pack/main/pack.toml}"
INSTANCE="${INSTANCE:-$HOME/.var/app/com.atlauncher.ATLauncher/data/instances/OccultEyesCreateModpack}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${OUT:-$HOME/Documents}"

# Read pack name/version/loader straight out of pack.toml so they cannot drift.
NAME=$(grep -m1 '^name'     "$HERE/pack.toml" | cut -d'"' -f2)
VER=$(grep -m1  '^version'  "$HERE/pack.toml" | cut -d'"' -f2)
MC=$(grep -m1   '^minecraft' "$HERE/pack.toml" | cut -d'"' -f2)
NEO=$(grep -m1  '^neoforge'  "$HERE/pack.toml" | cut -d'"' -f2)
[ -n "$MC" ] && [ -n "$NEO" ] || { echo "could not read versions from pack.toml" >&2; exit 1; }

# Mods CurseForge blocks from API download; players cannot fetch these themselves.
MANUAL=(create-shimmer-1.3.1.jar buildersjetpackmod-3.1-1.21.1.jar)

BOOT="$HERE/tools/packwiz-installer-bootstrap.jar"
if [ ! -f "$BOOT" ]; then
  echo "fetching packwiz-installer-bootstrap..."
  curl -sLo "$BOOT" https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar
fi

B=$(mktemp -d); trap 'rm -rf "$B"' EXIT
mkdir -p "$B/overrides/mods"
cp "$BOOT" "$B/overrides/packwiz-installer-bootstrap.jar"
for m in "${MANUAL[@]}"; do
  [ -f "$INSTANCE/mods/$m" ] || { echo "missing $m in $INSTANCE/mods" >&2; exit 1; }
  cp "$INSTANCE/mods/$m" "$B/overrides/mods/"
done

cat > "$B/modrinth.index.json" <<JSON
{
  "formatVersion": 1,
  "game": "minecraft",
  "versionId": "$VER",
  "name": "$NAME",
  "summary": "Bootstrap installer. Mods and configs sync automatically on every launch via packwiz.",
  "files": [],
  "dependencies": {
    "minecraft": "$MC",
    "neoforge": "$NEO"
  }
}
JSON

sed "s|__PACK_URL__|$PACK_URL|g" "$HERE/tools/SETUP-README.txt" > "$B/overrides/SETUP-README.txt"

DEST="$OUT/${NAME// /-}-$VER.mrpack"
rm -f "$DEST"
( cd "$B" && zip -q -r -X "$DEST" modrinth.index.json overrides )
echo "built $DEST"
echo "  minecraft $MC / neoforge $NEO / pack $VER"
echo "  url: $PACK_URL"
