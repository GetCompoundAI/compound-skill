#!/usr/bin/env bash
set -euo pipefail

REPO="getcompoundai/compound-skill"
if [ -z "${COMPOUND_INSTALL_DIR:-}" ]; then
  case "$(uname -s)" in
    Darwin) INSTALL_DIR="/usr/local/bin" ;;
    *)      INSTALL_DIR="$HOME/.local/bin" ;;
  esac
else
  INSTALL_DIR="$COMPOUND_INSTALL_DIR"
fi

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }
error() { printf '\033[1;31merror: %s\033[0m\n' "$*" >&2; exit 1; }

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
  local platform version archive_name url tmp

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

  mkdir -p "$INSTALL_DIR" 2>/dev/null || true
  if [ -w "$INSTALL_DIR" ]; then
    install -m 755 "${tmp}/compound-${platform}" "${INSTALL_DIR}/compound"
  else
    info "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo install -m 755 "${tmp}/compound-${platform}" "${INSTALL_DIR}/compound"
  fi

  info "Installed compound to ${INSTALL_DIR}/compound"

  if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    info ""
    info "Add to your PATH:"
    info "  export PATH=\"${INSTALL_DIR}:\$PATH\""
  fi

  info ""
  info "Next steps:"
  info "  compound login          # authenticate"
  info "  compound ask 'hello'    # send a message"
}

main "$@"
