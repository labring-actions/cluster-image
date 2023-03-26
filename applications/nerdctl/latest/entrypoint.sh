#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

if [ -z ${uninstall} ]; then
  bash scripts/enable.sh
elif [ -n ${uninstall} ]; then
  bash scripts/disable.sh
fi
