#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION="$(cat "$ROOT/VERSION")"
OUT="${ROOT}/../starship-shellcraft-${VERSION}.tar.gz"
tar -C "$ROOT/.." \
  --exclude='.git' \
  --exclude='*.deb' \
  --exclude='*.rpm' \
  --exclude='*.pkg.tar.zst' \
  -czf "$OUT" "starship-shellcraft"
mv "$OUT" "$ROOT/starship-shellcraft-${VERSION}.tar.gz"
echo "Built: $ROOT/starship-shellcraft-${VERSION}.tar.gz"
