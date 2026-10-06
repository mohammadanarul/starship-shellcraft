#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/mohammadanarul/starship-shellcraft.git"
BRANCH="main"

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "==> Downloading Starship Shellcraft..."

if command -v git >/dev/null 2>&1; then

    git clone \
        --depth 1 \
        --branch "$BRANCH" \
        "$REPO" \
        "$TMP_DIR/starship-shellcraft"

else

    echo "==> git is not installed."
    echo "==> Downloading source archive..."

    mkdir -p "$TMP_DIR/archive"

    curl -fsSL \
        "https://github.com/mohammadanarul/starship-shellcraft/archive/refs/heads/${BRANCH}.tar.gz" \
        -o "$TMP_DIR/archive/starship-shellcraft.tar.gz"

    tar -xzf \
        "$TMP_DIR/archive/starship-shellcraft.tar.gz" \
        -C "$TMP_DIR/archive"

    mv \
        "$TMP_DIR/archive/starship-shellcraft-${BRANCH}" \
        "$TMP_DIR/starship-shellcraft"

fi

cd "$TMP_DIR/starship-shellcraft"

chmod +x ./shellcraft

echo "==> Starting Starship Shellcraft installer..."

exec ./shellcraft install "$@"