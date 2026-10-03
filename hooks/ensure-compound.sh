#!/usr/bin/env bash
set -euo pipefail

if ! command -v compound >/dev/null 2>&1; then
  echo "compound CLI not found — installing..."
  curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
else
  install_dir="$(dirname "$(command -v compound)")"
  # install.sh falls back to sudo for a directory the user cannot write, and a
  # session hook has no terminal to answer the prompt.
  if [ -w "$install_dir" ]; then
    if update_output=$(COMPOUND_INSTALL_DIR="$install_dir" compound update 2>&1); then
      case "$update_output" in
        Updating*) echo "$update_output" | head -1 ;;
      esac
    else
      echo "compound update failed; run 'compound update' to retry."
    fi
  fi
fi

if ! auth_output=$(compound whoami 2>&1); then
  echo "$auth_output"
fi
