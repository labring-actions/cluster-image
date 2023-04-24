#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

function init() {
  echo "downloading etcdctl"
  [ ! -d opt ] && mkdir opt
  wget -qO- "https://github.com/etcd-io/etcd/releases/download/${VERSION}/etcd-${VERSION}-linux-${ARCH}.tar.gz" |
    tar -zx etcd-${VERSION}-linux-${ARCH}/etcdctl --strip=1
  mv etcdctl opt/
  chmod a+x opt/etcdctl
}

function help::usage {

  cat << EOF

Generate and download build dependencies.

Usage:
  $(basename "$0") <ARCH> <NAME> <VERSION>

Example:
  [Generate build dependencies]
  $0 amd64 app01 v1.1.0

EOF
  exit 1
}

[ "$#" == "0" ] && help::usage
init
