#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function enable(){
  kubectl apply -f ../manifests/multus-daemonset-thick.yml
}
enable
