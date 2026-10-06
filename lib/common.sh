#!/usr/bin/env bash

SC_VERSION="$(cat "$SC_ROOT/VERSION" 2>/dev/null || echo "1.0.0")"
SC_NAME="starship-shellcraft"
SC_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/shellcraft"
SC_STATE_FILE="$SC_CONFIG_DIR/state"
SC_THEME_DIR="$SC_CONFIG_DIR/themes"
SC_STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
SC_BASHRC="$HOME/.bashrc"
SC_MARK_START="# >>> starship-shellcraft >>>"
SC_MARK_END="# <<< starship-shellcraft <<<"

info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

ensure_dirs() {
  mkdir -p "$SC_CONFIG_DIR" "$SC_THEME_DIR" "${XDG_BIN_HOME:-$HOME/.local/bin}"
}

path_in_path() {
  command -v "$1" >/dev/null 2>&1
}

replace_managed_block() {
  local new_block="$1"
  touch "$SC_BASHRC"
  awk -v start="$SC_MARK_START" -v end="$SC_MARK_END" '
    $0 == start {skip=1; next}
    $0 == end {skip=0; next}
    !skip {print}
  ' "$SC_BASHRC" > "$SC_BASHRC.tmp"
  printf '%s\n' "$new_block" >> "$SC_BASHRC.tmp"
  mv "$SC_BASHRC.tmp" "$SC_BASHRC"
}

save_state() {
  ensure_dirs
  cat > "$SC_STATE_FILE" <<EOF
version=$SC_VERSION
theme=${SC_THEME:-tokyo-night}
installed_at=$(date -Is 2>/dev/null || date)
EOF
}

load_state() {
  SC_THEME="tokyo-night"
  [[ -f "$SC_STATE_FILE" ]] && source "$SC_STATE_FILE" 2>/dev/null || true
}

is_root() { [[ "${EUID:-$(id -u)}" -eq 0 ]]; }

sudo_cmd() {
  if is_root; then
    "$@"
  else
    sudo "$@"
  fi
}
