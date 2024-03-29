#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

if [ -z ${uninstall} ]; then
  bash scripts/install.sh
elif [ -n ${uninstall} ]; then
  bash scripts/cleanup.sh
fi
