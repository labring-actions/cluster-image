#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

function init() {
  rm -rf opt/ && mkdir -p opt/
  wget -qO- "https://github.com/yashbhutwala/kubectl-df-pv/releases/download/${VERSION}/kubectl-df-pv_${VERSION}_linux_${ARCH}.tar.gz" | tar -zx df-pv
  mv df-pv opt/kubectl-dfpv && chmod a+x opt/kubectl-dfpv
}
function main() {
  if [ $# -ne 3 ]; then
    echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
    exit 1
  else
    init
  fi
}

main $@
