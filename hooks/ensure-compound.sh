#!/usr/bin/env bash
set -euo pipefail

if ! command -v compound >/dev/null 2>&1; then
  echo "compound CLI not found — installing..."
  curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
fi

if ! auth_output=$(compound whoami 2>&1); then
  echo "$auth_output"
fi
