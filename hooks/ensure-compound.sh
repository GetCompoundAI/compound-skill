#!/usr/bin/env bash
set -euo pipefail

if ! command -v compound >/dev/null 2>&1; then
  echo "compound CLI not found — installing..."
  curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
else
  # `compound update` never prompts: an install directory it cannot write fails
  # with a `sudo compound update` hint instead of waiting on a password.
  if update_output=$(compound update 2>&1); then
    case "$update_output" in
      Updating*) echo "$update_output" | head -1 ;;
    esac
  else
    echo "$update_output" | tail -1
  fi
fi

if ! auth_output=$(compound whoami 2>&1); then
  echo "$auth_output"
fi
