#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

script_name=$(basename "$0")
TARGET=${script_name%.*}

source common
"gen_$script_name" "$@"

if ! rmdir "$TARGET" 2>/dev/null; then
  cat <<EOF >>"Kubefile"
COPY $TARGET $TARGET
EOF
  "install_$script_name" "$@"
fi
