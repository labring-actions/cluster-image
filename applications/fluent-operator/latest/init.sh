#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
wget -qO- https://github.com/fluent/fluent-operator/releases/download/${VERSION}/fluent-operator.tgz | tar -zx
mv fluent-operator charts/

cat >charts/fluent-operator.values.yaml<<EOF
fluentd:
  enable: true
EOF
