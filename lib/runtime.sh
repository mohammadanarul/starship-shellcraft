#!/usr/bin/env bash

install_launcher() {
  local target_dir="/usr/local/bin"
  if [[ ! -w "$target_dir" ]]; then
    target_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
    mkdir -p "$target_dir"
  fi

  local target="$target_dir/starship-shellcraft"
  local source="$SC_ROOT/shellcraft"

  if [[ "$target_dir" == "/usr/local/bin" ]]; then
    sudo_cmd install -m 0755 "$source" "$target"
    sudo_cmd mkdir -p /usr/share/starship-shellcraft
    sudo_cmd cp -r "$SC_ROOT/lib" "$SC_ROOT/themes" "$SC_ROOT/VERSION" /usr/share/starship-shellcraft/
    sudo_cmd sed -i 's#^SC_ROOT=.*#SC_ROOT="/usr/share/starship-shellcraft"#' "$target"
    sudo_cmd ln -sf "$target" /usr/local/bin/ssc
  else
    install -m 0755 "$source" "$target"
    mkdir -p "$HOME/.local/share/starship-shellcraft"
    cp -r "$SC_ROOT/lib" "$SC_ROOT/themes" "$SC_ROOT/VERSION" "$HOME/.local/share/starship-shellcraft/"
    sed -i 's#^SC_ROOT=.*#SC_ROOT="$HOME/.local/share/starship-shellcraft"#' "$target"
    ln -sf "$target" "$target_dir/ssc"
  fi

  ok "CLI installed: $target"
  ok "Short command: ssc"
}

copy_themes() {
  ensure_dirs
  cp -f "$SC_ROOT"/themes/*.toml "$SC_THEME_DIR/"
}

configure_bashrc() {
  local block
  block="$SC_MARK_START
# Starship Shellcraft managed configuration
export PATH=\"\$HOME/.local/bin:\$PATH\"

# bash-completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# ble.sh
if [[ -f \"\$HOME/.local/share/blesh/ble.sh\" ]]; then
  source \"\$HOME/.local/share/blesh/ble.sh\"
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval \"\$(zoxide init bash)\"
fi

# Starship
if command -v starship >/dev/null 2>&1; then
  eval \"\$(starship init bash)\"
fi
$SC_MARK_END"
  replace_managed_block "$block"
}

select_first_theme() {
  load_state
  if [[ -f "$SC_STARSHIP_CONFIG" ]] && ! starship_config_is_managed; then
    echo
    warn "Found your own Starship config: $SC_STARSHIP_CONFIG"
    local answer
    ask answer "Replace it with a Shellcraft theme? (a backup is saved) [Y/n]: " "y"
    if [[ "$answer" =~ ^[Nn]$ ]]; then
      SC_THEME="custom"
      save_state
      ok "Keeping your own Starship config."
      return
    fi
  fi

  echo
  theme_list
  echo
  info "[Nerd Font] themes need a Nerd Font in your terminal. No Nerd Font? Pick 'minimal'."
  local chosen
  ask chosen "Choose theme (name or number) [tokyo-night]: " "tokyo-night"
  chosen="$(theme_resolve "$chosen")"
  if [[ -z "$chosen" || ! -f "$SC_THEME_DIR/$chosen.toml" ]]; then
    warn "Invalid theme. Falling back to tokyo-night."
    chosen="tokyo-night"
  fi
  theme_set "$chosen"
}

install_cmd() {
  detect_platform
  echo "Starship Shellcraft v$SC_VERSION"
  echo "Platform: $SC_OS_NAME | WSL: $SC_WSL | Arch: $SC_ARCH"
  echo

  if [[ "$SC_PACKAGE_MANAGER" == "unknown" ]]; then
    err "No supported package manager detected."
    return 1
  fi

  install_dependencies
  ensure_dirs
  copy_themes
  select_first_theme
  configure_bashrc
  install_launcher
  save_state

  echo
  ok "Installation complete."
  info "Default startup path: $SC_DEFAULT_PATH"
  if [[ "$SC_WSL" == "yes" ]]; then
    info "WSL tip: work inside ~ (Linux home), not /mnt/c. /mnt/c is slow for Starship and git."
  fi
  info "Run: ssc info"
  info "Run: ssc theme list"
  info "Run: source ~/.bashrc"
}

repair_cmd() {
  detect_platform
  ensure_dirs
  copy_themes
  info "Repairing dependencies and shell configuration..."
  install_dependencies
  configure_bashrc
  install_launcher
  ok "Repair complete."
}

doctor_cmd() {
  detect_platform
  load_state
  echo "Starship Shellcraft Doctor"
  echo "--------------------------"
  printf "OS              : %s\n" "$SC_OS_NAME"
  printf "Package manager  : %s\n" "$SC_PACKAGE_MANAGER"
  printf "Architecture     : %s\n" "$SC_ARCH"
  printf "WSL              : %s\n" "$SC_WSL"
  printf "User             : %s\n" "$SC_USER"
  printf "Shell            : %s\n" "$SC_SHELL"
  printf "Default path     : %s\n" "$SC_DEFAULT_PATH"
  printf "Theme            : %s\n" "$SC_THEME"
  for cmd in starship fzf zoxide git; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf "✓ %-16s installed\n" "$cmd"
    else
      printf "✗ %-16s missing\n" "$cmd"
    fi
  done
  [[ -f "$SC_BASHRC" ]] && echo "✓ bashrc            found" || echo "✗ bashrc            missing"
  [[ -f "$SC_STARSHIP_CONFIG" ]] && echo "✓ starship.toml     found" || echo "✗ starship.toml     missing"
}

info_cmd() {
  detect_platform
  load_state
  echo "Starship Shellcraft"
  echo "==================="
  printf "Version            : %s\n" "$SC_VERSION"
  printf "OS                 : %s\n" "$SC_OS_NAME"
  printf "Package manager    : %s\n" "$SC_PACKAGE_MANAGER"
  printf "Architecture       : %s\n" "$SC_ARCH"
  printf "WSL                : %s\n" "$SC_WSL"
  printf "Kernel             : %s\n" "$SC_KERNEL"
  printf "User               : %s\n" "$SC_USER"
  printf "Shell              : %s\n" "$SC_SHELL"
  printf "Bash               : %s\n" "${BASH_VERSION:-unknown}"
  printf "Default path       : %s\n" "$SC_DEFAULT_PATH"
  [[ -n "${SC_WINDOWS_HOME:-}" ]] && printf "Windows home       : %s\n" "$SC_WINDOWS_HOME"
  printf "Current theme      : %s\n" "$SC_THEME"
  printf "Config             : %s\n" "$SC_CONFIG_DIR"
  printf "Starship config    : %s\n" "$SC_STARSHIP_CONFIG"
}

update_cmd() {
  info "Update is release-based."
  if command -v curl >/dev/null 2>&1; then
    info "Use the latest GitHub release installer/package to update."
  fi
  warn "Automatic self-update will be enabled in a future release."
}

uninstall_cmd() {
  echo "This removes Shellcraft-managed configuration and CLI files."
  local answer
  ask answer "Continue? [y/N]: " "n"
  [[ "$answer" =~ ^[Yy]$ ]] || { echo "Cancelled."; return 0; }

  awk -v start="$SC_MARK_START" -v end="$SC_MARK_END" '
    $0 == start {skip=1; next}
    $0 == end {skip=0; next}
    !skip {print}
  ' "$SC_BASHRC" > "$SC_BASHRC.tmp" 2>/dev/null || true
  [[ -f "$SC_BASHRC.tmp" ]] && mv "$SC_BASHRC.tmp" "$SC_BASHRC"

  rm -rf "$SC_CONFIG_DIR" "$HOME/.local/share/starship-shellcraft"
  if [[ -L /usr/local/bin/ssc || -f /usr/local/bin/starship-shellcraft ]]; then
    sudo_cmd rm -f /usr/local/bin/ssc /usr/local/bin/starship-shellcraft
    sudo_cmd rm -rf /usr/share/starship-shellcraft
  fi
  rm -f "$HOME/.local/bin/ssc" "$HOME/.local/bin/starship-shellcraft"
  ok "Shellcraft removed. Starship itself was left untouched."
}

help_cmd() {
  cat <<'EOF'
Starship Shellcraft

Usage:
  starship-shellcraft <command>
  ssc <command>

Commands:
  install                 Install/configure Shellcraft
  info                    Show system and Shellcraft information
  doctor                  Diagnose installation
  repair                  Repair dependencies/configuration
  update                  Show update guidance
  uninstall               Remove Shellcraft configuration and CLI
  version                 Show version
  help                    Show this help

Theme manager:
  theme                   Show theme commands
  theme list              List available themes
  theme current           Show current theme
  theme set <name|num>    Change theme without reinstalling
  theme preview [name]    Preview a theme
  theme reset             Reset to Tokyo Night

Built-in themes:
  tokyo-night         powerline   (Nerd Font)
  nord                powerline   (Nerd Font)
  dracula             powerline   (Nerd Font)
  gruvbox             powerline   (Nerd Font)
  catppuccin-mocha    powerline   (Nerd Font)
  minimal             plain text  (any font)

Notes:
  Supported package managers: APT, Pacman, DNF, Zypper.
  Your old starship.toml is backed up before a theme replaces it.
EOF
}

menu_cmd() {
  while true; do
    clear 2>/dev/null || true
    echo "╭────────────────────────────────────╮"
    echo "│      Starship Shellcraft           │"
    echo "╰────────────────────────────────────╯"
    echo "1) Install / Configure"
    echo "2) Theme Manager"
    echo "3) System Info"
    echo "4) Doctor"
    echo "5) Repair"
    echo "6) Help"
    echo "7) Uninstall"
    echo "0) Exit"
    local choice
    ask choice "Select: " "0"
    case "$choice" in
      1) install_cmd ;;
      2) theme_menu ;;
      3) info_cmd ;;
      4) doctor_cmd ;;
      5) repair_cmd ;;
      6) help_cmd ;;
      7) uninstall_cmd ;;
      0) exit 0 ;;
      *) warn "Invalid option." ;;
    esac
    echo
    local _pause
    ask _pause "Press Enter to continue..." ""
  done
}

theme_menu() {
  while true; do
    echo
    echo "Theme Manager"
    echo "1) List"
    echo "2) Current"
    echo "3) Set"
    echo "4) Preview"
    echo "5) Reset"
    echo "0) Back"
    local choice t
    ask choice "Select: " "0"
    case "$choice" in
      1) theme_list ;;
      2) theme_current ;;
      3) theme_list; ask t "Theme (name or number): " ""; theme_set "$t" || true ;;
      4) ask t "Theme [current]: " "$SC_THEME"; theme_preview "$t" || true ;;
      5) theme_reset ;;
      0) return ;;
      *) warn "Invalid option." ;;
    esac
  done
}

main() {
  local cmd="${1:-menu}"
  shift || true
  case "$cmd" in
    install) install_cmd "$@" ;;
    info) info_cmd "$@" ;;
    doctor) doctor_cmd "$@" ;;
    repair) repair_cmd "$@" ;;
    update) update_cmd "$@" ;;
    uninstall) uninstall_cmd "$@" ;;
    theme)
      case "${1:-}" in
        list) theme_list ;;
        current) theme_current ;;
        set) shift; theme_set "${1:-}" ;;
        preview) shift; theme_preview "${1:-}" ;;
        reset) theme_reset ;;
        *) theme_menu ;;
      esac ;;
    version|--version|-v) echo "starship-shellcraft $SC_VERSION" ;;
    help|--help|-h) help_cmd ;;
    menu) menu_cmd ;;
    *) err "Unknown command: $cmd"; help_cmd; return 1 ;;
  esac
}