#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION="$(cat "$ROOT/VERSION")"
NAME="starship-shellcraft"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

STAGE="$WORK/${NAME}-${VERSION}"

mkdir -p "$STAGE"

cp -a \
  "$ROOT/lib" \
  "$ROOT/themes" \
  "$ROOT/VERSION" \
  "$ROOT/shellcraft" \
  "$STAGE/"

tar -C "$WORK" \
  -czf "$WORK/${NAME}-${VERSION}.tar.gz" \
  "${NAME}-${VERSION}"

cat > "$WORK/PKGBUILD" <<EOF
# Maintainer: Starship Shellcraft contributors

pkgname=starship-shellcraft
pkgver=$VERSION
pkgrel=1

pkgdesc="Modern Bash environment powered by Starship"

arch=('any')
license=('MIT')

depends=(
  'bash'
  'curl'
  'git'
  'fzf'
  'bash-completion'
)

source=(
  "starship-shellcraft-\${pkgver}.tar.gz"
)

sha256sums=('SKIP')

package() {

  install -dm755 \
    "\$pkgdir/usr/share/starship-shellcraft"

  cp -a \
    "\$srcdir/starship-shellcraft-\${pkgver}/lib" \
    "\$pkgdir/usr/share/starship-shellcraft/"

  cp -a \
    "\$srcdir/starship-shellcraft-\${pkgver}/themes" \
    "\$pkgdir/usr/share/starship-shellcraft/"

  install -Dm644 \
    "\$srcdir/starship-shellcraft-\${pkgver}/VERSION" \
    "\$pkgdir/usr/share/starship-shellcraft/VERSION"

  install -Dm755 \
    "\$srcdir/starship-shellcraft-\${pkgver}/shellcraft" \
    "\$pkgdir/usr/share/starship-shellcraft/shellcraft"

  install -dm755 \
    "\$pkgdir/usr/bin"

  cat > "\$pkgdir/usr/bin/starship-shellcraft" <<'LAUNCHER'
#!/usr/bin/env bash
set -euo pipefail

SC_ROOT="/usr/share/starship-shellcraft"

source "\$SC_ROOT/lib/common.sh"
source "\$SC_ROOT/lib/detect.sh"
source "\$SC_ROOT/lib/packages.sh"
source "\$SC_ROOT/lib/theme.sh"
source "\$SC_ROOT/lib/runtime.sh"

main "\$@"
LAUNCHER

  chmod 0755 \
    "\$pkgdir/usr/bin/starship-shellcraft"

  ln -s \
    starship-shellcraft \
    "\$pkgdir/usr/bin/ssc"
}
EOF

if command -v makepkg >/dev/null 2>&1; then

    if [[ "$(id -u)" -eq 0 ]]; then

        if ! id shellcraft-builder >/dev/null 2>&1; then
            useradd \
              -m \
              -u 1000 \
              -s /bin/bash \
              shellcraft-builder
        fi

        chown -R \
          shellcraft-builder:shellcraft-builder \
          "$WORK"

        runuser \
          -u shellcraft-builder \
          -- bash -lc \
          "cd '$WORK' && makepkg --clean --cleanbuild --force"

    else

        cd "$WORK"

        makepkg \
          --clean \
          --cleanbuild \
          --force

    fi

    cp "$WORK"/*.pkg.tar.* "$ROOT/"

    echo "Built Arch package successfully."

else

    cp "$WORK/PKGBUILD" \
      "$ROOT/packaging/arch/PKGBUILD"

    echo "makepkg not installed."
    echo "Standalone PKGBUILD generated."

fi