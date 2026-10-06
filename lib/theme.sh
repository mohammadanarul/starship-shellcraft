#!/usr/bin/env bash

theme_names() {
  find "$SC_THEME_DIR" -maxdepth 1 -type f -name '*.toml' -printf '%f\n' 2>/dev/null |
    sed 's/\.toml$//' | sort
}

theme_list() {
  echo "Available themes:"
  while read -r t; do
    [[ -n "$t" ]] && printf '  • %s%s\n' "$t" "$([[ "$t" == "$SC_THEME" ]] && echo '  (current)' || true)"
  done < <(theme_names)
}

theme_current() {
  load_state
  echo "${SC_THEME:-tokyo-night}"
}

theme_set() {
  local requested="${1:-}"
  ensure_dirs
  [[ -n "$requested" ]] || { err "Usage: starship-shellcraft theme set <name>"; return 1; }
  if [[ ! -f "$SC_THEME_DIR/$requested.toml" ]]; then
    err "Theme not found: $requested"
    theme_list
    return 1
  fi
  cp "$SC_THEME_DIR/$requested.toml" "$SC_STARSHIP_CONFIG"
  SC_THEME="$requested"
  save_state
  ok "Theme set to: $requested"
  info "Reload your shell with: source ~/.bashrc"
}

theme_reset() {
  theme_set tokyo-night
}

theme_preview() {
  local requested="${1:-$SC_THEME}"
  [[ -f "$SC_THEME_DIR/$requested.toml" ]] || { err "Theme not found: $requested"; return 1; }
  if command -v starship >/dev/null 2>&1; then
    echo "Preview: $requested"
    STARSHIP_CONFIG="$SC_THEME_DIR/$requested.toml" starship prompt 2>/dev/null || true
  else
    warn "Starship is not installed yet."
  fi
}
