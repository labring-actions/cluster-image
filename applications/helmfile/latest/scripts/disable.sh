#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function log::info() {
  printf "%s \033[32minfo \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

NAME="helmfile"
sealos exec -r master "
binary=/usr/local/bin/helmfile
if ! [ -x $binary ]; then
  echo "Helmfile is not installed"
  exit 0
fi
echo 'Removing Helmfile ...'
rm -rf /root/.local/share/helm/plugins/helm-diff
rm -rf /usr/bin/helm
rm -rf /usr/bin/helmfile
"
log::info "${NAME} has been removed"
