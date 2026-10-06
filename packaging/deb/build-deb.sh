#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION="$(cat "$ROOT/VERSION")"
PKG="starship-shellcraft"
ARCH="all"
OUT="$ROOT/${PKG}_${VERSION}_${ARCH}.deb"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$WORK/DEBIAN" "$WORK/usr/share/$PKG"
cp -r "$ROOT/lib" "$ROOT/themes" "$ROOT/VERSION" "$WORK/usr/share/$PKG/"
cp "$ROOT/shellcraft" "$WORK/usr/share/$PKG/shellcraft"
chmod 0755 "$WORK/usr/share/$PKG/shellcraft"

cat > "$WORK/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: Starship Shellcraft contributors
Depends: bash, curl, git
Description: Modern Bash environment powered by Starship
 A portable Bash customization utility for Debian and Ubuntu.
 Includes Starship themes, autosuggestions, completion, fuzzy search
 and smart directory navigation.
EOF

cat > "$WORK/usr/share/$PKG/launcher" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SC_ROOT="/usr/share/starship-shellcraft"
source "$SC_ROOT/lib/common.sh"
source "$SC_ROOT/lib/detect.sh"
source "$SC_ROOT/lib/packages.sh"
source "$SC_ROOT/lib/theme.sh"
source "$SC_ROOT/lib/runtime.sh"
main "$@"
EOF
chmod 0755 "$WORK/usr/share/$PKG/launcher"

mkdir -p "$WORK/usr/bin"
ln -s "/usr/share/$PKG/launcher" "$WORK/usr/bin/starship-shellcraft"
ln -s "/usr/share/$PKG/launcher" "$WORK/usr/bin/ssc"

dpkg-deb --build "$WORK" "$OUT"
echo "Built: $OUT"
