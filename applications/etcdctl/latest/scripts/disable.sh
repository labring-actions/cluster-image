#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

sealos exec -r master "rm -rf /usr/local/bin/etcdctl"
sealos exec -r master "rm -rf /usr/local/bin/etcdctl.sh"
