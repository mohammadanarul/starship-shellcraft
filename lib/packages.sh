#!/usr/bin/env bash

package_install() {
  require_package_manager || return 1
  case "$SC_PACKAGE_MANAGER" in
    apt)
      info "Installing dependencies with APT..."
      sudo_cmd apt-get update
      sudo_cmd apt-get install -y curl git fzf bash-completion build-essential ;;
    pacman)
      info "Installing dependencies with Pacman..."
      sudo_cmd pacman -Sy --needed --noconfirm curl git fzf bash-completion base-devel ;;
    dnf)
      info "Installing dependencies with DNF..."
      sudo_cmd dnf install -y curl git fzf bash-completion gcc make ;;
    zypper)
      info "Installing dependencies with Zypper..."
      sudo_cmd zypper --non-interactive refresh
      sudo_cmd zypper --non-interactive install curl git fzf bash-completion gcc make ;;
  esac
}

install_starship() {
  if command -v starship >/dev/null 2>&1; then
    ok "Starship already installed."
    return
  fi
  info "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_blesh() {
  if [[ -f "$HOME/.local/share/blesh/ble.sh" || -f "$HOME/.local/share/blesh/ble.sh.out" ]]; then
    ok "ble.sh already installed."
    return
  fi
  info "Installing ble.sh..."
  mkdir -p "$HOME/.local/share"
  local dir="$HOME/.local/share/blesh.git"
  if [[ ! -d "$dir" ]]; then
    git clone --depth 1 https://github.com/akinomyoga/ble.sh.git "$dir" >/dev/null 2>&1 || {
      warn "ble.sh clone failed."
      return 0
    }
  fi
  make -C "$dir" install PREFIX="$HOME/.local" >/dev/null 2>&1 || \
    warn "ble.sh build/install failed."
}

install_zoxide() {
  if command -v zoxide >/dev/null 2>&1; then
    ok "zoxide already installed."
    return
  fi
  info "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_dependencies() {
  package_install
  install_starship
  install_blesh
  install_zoxide
}
