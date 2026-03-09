#!/usr/bin/env bash
set -euo pipefail

if ! command -v compound >/dev/null 2>&1; then
  echo "compound CLI not found — installing..."
  curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
fi

if [ -z "${COMPOUND_TOKEN:-}" ] && [ ! -f "$HOME/.compound/config.json" ]; then
  echo "Not logged in. Run 'compound login' to authenticate."
fi
