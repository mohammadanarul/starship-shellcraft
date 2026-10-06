#!/usr/bin/env bash

detect_platform() {
  SC_OS_ID="unknown"
  SC_OS_NAME="Unknown Linux"
  SC_WSL="no"
  SC_ARCH="$(uname -m)"
  SC_KERNEL="$(uname -r)"
  SC_SHELL="${SHELL:-/bin/bash}"
  SC_USER="${USER:-$(id -un)}"
  SC_PACKAGE_MANAGER="unknown"

  if [[ -r /etc/os-release ]]; then
    source /etc/os-release
    SC_OS_ID="${ID:-unknown}"
    SC_OS_NAME="${PRETTY_NAME:-${NAME:-Unknown Linux}}"
  fi

  if grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null || [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
    SC_WSL="yes"
  fi

  SC_WINDOWS_USER=""
  SC_DEFAULT_PATH="$HOME"

  if [[ "$SC_WSL" == "yes" ]] && command -v powershell.exe >/dev/null 2>&1; then
    SC_WINDOWS_USER="$(powershell.exe -NoProfile -Command '[Environment]::UserName' 2>/dev/null | tr -d '\r\n' || true)"
    if [[ -n "$SC_WINDOWS_USER" && -d "/mnt/c/Users/$SC_WINDOWS_USER" ]]; then
      SC_DEFAULT_PATH="/mnt/c/Users/$SC_WINDOWS_USER"
    fi
  fi

  case "$SC_OS_ID" in
    debian|ubuntu|linuxmint|pop|kali|elementary|zorin)
      SC_PACKAGE_MANAGER="apt" ;;
    arch|manjaro|endeavouros|garuda|artix)
      SC_PACKAGE_MANAGER="pacman" ;;
    fedora|rhel|rocky|almalinux|centos|ol)
      SC_PACKAGE_MANAGER="dnf" ;;
    opensuse*|sles|sles_sap)
      SC_PACKAGE_MANAGER="zypper" ;;
    *)
      if command -v apt-get >/dev/null 2>&1; then SC_PACKAGE_MANAGER="apt"
      elif command -v pacman >/dev/null 2>&1; then SC_PACKAGE_MANAGER="pacman"
      elif command -v dnf >/dev/null 2>&1; then SC_PACKAGE_MANAGER="dnf"
      elif command -v zypper >/dev/null 2>&1; then SC_PACKAGE_MANAGER="zypper"
      fi ;;
  esac
}

require_package_manager() {
  if [[ "$SC_PACKAGE_MANAGER" == "unknown" ]]; then
    err "Unsupported Linux distribution/package manager."
    err "Supported: APT, Pacman, DNF, Zypper."
    return 1
  fi
}
