#!/usr/bin/env bash
set -euo pipefail

REPO="getcompoundai/compound-skill"

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }
error() { printf '\033[1;31merror: %s\033[0m\n' "$*" >&2; exit 1; }

pick_install_dir() {
  if [ -n "${COMPOUND_INSTALL_DIR:-}" ]; then
    echo "$COMPOUND_INSTALL_DIR"
    return
  fi

  # Try /usr/local/bin first (always on PATH)
  if [ -w /usr/local/bin ]; then
    echo "/usr/local/bin"
    return
  fi

  # Fallback: ~/.local/bin (no sudo needed)
  echo "$HOME/.local/bin"
}

detect_platform() {
  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$os" in
    linux)  os="linux" ;;
    darwin) os="darwin" ;;
    *)      error "Unsupported OS: $os" ;;
  esac

  case "$arch" in
    x86_64|amd64)  arch="x64" ;;
    aarch64|arm64) arch="arm64" ;;
    *)             error "Unsupported architecture: $arch" ;;
  esac

  echo "${os}-${arch}"
}

get_latest_version() {
  local url="https://api.github.com/repos/${REPO}/releases/latest"
  if command -v curl >/dev/null; then
    curl -fsSL "$url" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'
  elif command -v wget >/dev/null; then
    wget -qO- "$url" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'
  else
    error "curl or wget required"
  fi
}

download() {
  local url="$1" dest="$2"
  if command -v curl >/dev/null; then
    curl -fsSL "$url" -o "$dest"
  else
    wget -qO "$dest" "$url"
  fi
}

main() {
  local platform="" version="" archive_name="" url="" tmp="" install_dir=""

  platform="$(detect_platform)"
  info "Detected platform: ${platform}"

  version="${1:-$(get_latest_version)}"
  [ -z "$version" ] && error "Could not determine latest version. Pass version as argument: install.sh v0.1.0"
  info "Installing compound ${version}..."

  archive_name="compound-${platform}.tar.gz"
  url="https://github.com/${REPO}/releases/download/${version}/${archive_name}"

  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  info "Downloading ${url}..."
  download "$url" "${tmp}/${archive_name}"

  tar xzf "${tmp}/${archive_name}" -C "$tmp"

  install_dir="$(pick_install_dir)"
  mkdir -p "$install_dir" 2>/dev/null || true
  if [ -w "$install_dir" ]; then
    install -m 755 "${tmp}/compound-${platform}" "${install_dir}/compound"
  else
    info "Installing to ${install_dir} (requires sudo)..."
    sudo install -m 755 "${tmp}/compound-${platform}" "${install_dir}/compound"
  fi

  info "Installed compound to ${install_dir}/compound"

  if ! echo "$PATH" | tr ':' '\n' | grep -qx "$install_dir"; then
    local line="export PATH=\"${install_dir}:\$PATH\""
    local profile=""
    if [ -f "$HOME/.zshrc" ]; then
      profile="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
      profile="$HOME/.bashrc"
    elif [ -f "$HOME/.profile" ]; then
      profile="$HOME/.profile"
    fi

    if [ -n "$profile" ] && ! grep -qF "$install_dir" "$profile"; then
      echo "$line" >> "$profile"
      info "Added ${install_dir} to PATH in ${profile}"
      info "Restart your shell or run: source ${profile}"
    else
      info ""
      info "Add to your PATH:"
      info "  $line"
    fi
  fi

  info ""
  info "Next steps:"
  info "  compound login          # authenticate"
  info "  compound ask 'hello'    # send a message"
}

main "$@"
