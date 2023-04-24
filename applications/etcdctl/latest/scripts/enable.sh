#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

sealos scp -r master ../opt/etcdctl /usr/local/bin/etcdctl
sealos scp -r master ../scripts/etcdctl.sh /usr/local/bin/etcdctl.sh
sealos exec -r master "chmod +x /usr/local/bin/etcdctl.sh"
