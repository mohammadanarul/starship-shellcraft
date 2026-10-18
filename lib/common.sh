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
SC_REPO="${SC_REPO:-mohammadanarul/starship-shellcraft}"

info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# ask VAR "Prompt" [default]
# Always reads from the real terminal (/dev/tty), so it works with
# `curl ... | bash`, sudo, apt etc. Never fails under `set -e`.
# No terminal at all (CI/non-interactive) -> uses the default.
ask() {
  local __var="$1" __prompt="${2:-}" __default="${3:-}" __reply=""
  if { : </dev/tty; } 2>/dev/null; then
    printf '%s' "$__prompt" >/dev/tty
    IFS= read -r __reply </dev/tty || __reply=""
  elif [[ -t 0 ]]; then
    printf '%s' "$__prompt"
    IFS= read -r __reply || __reply=""
  else
    printf '%s%s\n' "$__prompt" "$__default"
  fi
  printf -v "$__var" '%s' "${__reply:-$__default}"
}

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
  if [[ -f "$SC_STATE_FILE" ]]; then
    local line
    line="$(grep '^theme=' "$SC_STATE_FILE" 2>/dev/null | tail -n 1 || true)"
    [[ -n "$line" ]] && SC_THEME="${line#theme=}"
  fi
  # If the user replaced starship.toml by hand, don't report a Shellcraft theme
  if [[ -f "$SC_STARSHIP_CONFIG" ]] &&
     ! head -n 1 "$SC_STARSHIP_CONFIG" | grep -qF "# starship-shellcraft theme:"; then
    SC_THEME="custom"
  fi
}

# Version stored in the state file (empty if never installed)
state_version() {
  [[ -f "$SC_STATE_FILE" ]] || return 0
  grep '^version=' "$SC_STATE_FILE" 2>/dev/null | tail -n 1 | cut -d= -f2- || true
}

# version_gt A B  -> true if A is newer than B
version_gt() {
  [[ "$1" != "$2" ]] &&
    [[ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -n 1)" == "$1" ]]
}

is_root() { [[ "${EUID:-$(id -u)}" -eq 0 ]]; }

sudo_cmd() {
  if is_root; then
    "$@"
  else
    sudo "$@"
  fi
}