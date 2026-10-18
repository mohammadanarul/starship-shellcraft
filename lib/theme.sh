#!/usr/bin/env bash

SC_THEME_MARK="# starship-shellcraft theme:"

theme_names() {
  find "$SC_THEME_DIR" -maxdepth 1 -type f -name '*.toml' -printf '%f\n' 2>/dev/null |
    sed 's/\.toml$//' | sort
}

# "nerd" if the theme needs a Nerd Font, "plain" otherwise
theme_font() {
  if grep -q 'requires a Nerd Font' "$SC_THEME_DIR/$1.toml" 2>/dev/null; then
    echo "nerd"
  else
    echo "plain"
  fi
}

theme_list() {
  load_state
  echo "Available themes:"
  local i=1 t tag cur
  while read -r t; do
    [[ -n "$t" ]] || continue
    tag=""; cur=""
    [[ "$(theme_font "$t")" == "nerd" ]] && tag="  [Nerd Font]" || tag="  [any font]"
    [[ "$t" == "$SC_THEME" ]] && cur="  (current)"
    printf '  %d) %-18s%s%s\n' "$i" "$t" "$tag" "$cur"
    i=$((i + 1))
  done < <(theme_names)
}

# Accepts a theme name or its number from theme_list
theme_resolve() {
  local input="${1:-}"
  if [[ "$input" =~ ^[0-9]+$ ]]; then
    theme_names | sed -n "${input}p"
  else
    echo "$input"
  fi
}

# true if ~/.config/starship.toml was written by Shellcraft
starship_config_is_managed() {
  [[ -f "$SC_STARSHIP_CONFIG" ]] && head -n 1 "$SC_STARSHIP_CONFIG" | grep -qF "$SC_THEME_MARK"
}

# Backup a user's own starship.toml before Shellcraft replaces it
backup_starship_config() {
  [[ -f "$SC_STARSHIP_CONFIG" ]] || return 0
  starship_config_is_managed && return 0
  local backup="$SC_STARSHIP_CONFIG.bak.$(date +%Y%m%d-%H%M%S)"
  cp "$SC_STARSHIP_CONFIG" "$backup"
  ok "Backup of your old Starship config: $backup"
}

theme_current() {
  load_state
  echo "${SC_THEME:-tokyo-night}"
}

# Write a theme to ~/.config/starship.toml (no messages)
theme_write() {
  local requested="$1"
  mkdir -p "$(dirname "$SC_STARSHIP_CONFIG")"
  backup_starship_config
  {
    echo "$SC_THEME_MARK $requested"
    cat "$SC_THEME_DIR/$requested.toml"
  } > "$SC_STARSHIP_CONFIG"
  SC_THEME="$requested"
  save_state
}

# Re-apply the current Shellcraft theme after themes were updated.
# Leaves a user's own (custom) config untouched.
theme_refresh() {
  load_state
  if [[ "$SC_THEME" != "custom" && -f "$SC_THEME_DIR/$SC_THEME.toml" ]]; then
    theme_write "$SC_THEME"
  else
    save_state
  fi
}

theme_set() {
  local requested
  requested="$(theme_resolve "${1:-}")"
  ensure_dirs
  [[ -n "$requested" ]] || { err "Usage: starship-shellcraft theme set <name|number>"; return 1; }
  if [[ ! -f "$SC_THEME_DIR/$requested.toml" ]]; then
    err "Theme not found: $requested"
    theme_list
    return 1
  fi
  theme_write "$requested"
  ok "Theme set to: $requested"
  if [[ "$(theme_font "$requested")" == "nerd" ]]; then
    info "This theme needs a Nerd Font in your terminal (e.g. FiraCode Nerd Font)."
    info "No Nerd Font? Use: ssc theme set minimal"
  fi
  info "Reload your shell with: source ~/.bashrc"
}

theme_reset() {
  theme_set tokyo-night
}

theme_preview() {
  local requested
  requested="$(theme_resolve "${1:-$SC_THEME}")"
  [[ -f "$SC_THEME_DIR/$requested.toml" ]] || { err "Theme not found: $requested"; return 1; }
  if command -v starship >/dev/null 2>&1; then
    echo "Preview: $requested"
    STARSHIP_CONFIG="$SC_THEME_DIR/$requested.toml" starship prompt 2>/dev/null |
      sed 's/\\\[//g; s/\\\]//g' || true
    echo
  else
    warn "Starship is not installed yet."
  fi
}