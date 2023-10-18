#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
wget -qO- https://github.com/kube-logging/logging-operator/archive/refs/tags/${VERSION#v}.tar.gz | tar -zx
mv logging-operator-${VERSION#v}/charts .
rm -rf charts/logging-demo

export FluentdImage_file="logging-operator-${VERSION#v}/pkg/sdk/logging/api/v1beta1/logging_types.go"
export DefaultFluentdImageTag=$(cat $FluentdImage_file | grep -E "^\s+(DefaultFluentdImageTag.*)" | cut -d '"' -f2)
export DefaultFluentbitImageTag=$(cat $FluentdImage_file | grep -E "^\s+(DefaultFluentbitImageTag.*)" | cut -d '"' -f2)
export DefaultFluentdConfigReloaderImageTag=$(cat $FluentdImage_file | grep -E "^\s+(DefaultFluentdConfigReloaderImageTag.*)" | cut -d '"' -f2)

export syslogngImage_file="logging-operator-${VERSION#v}/pkg/resources/syslogng/syslogng.go"
export syslogngImageTag=$(cat $syslogngImage_file | grep -E "^\s+(syslogngImageTag.*)" | cut -d '"' -f2)

rm -rf logging-operator-${VERSION#v}
rm -rf ${VERSION#v}.tar.gz

mkdir -p images/shim/
cat >images/shim/logging-operator-images.txt<<EOF
ghcr.io/kube-logging/fluentd:${DefaultFluentdImageTag}
docker.io/fluent/fluent-bit:${DefaultFluentbitImageTag}
ghcr.io/kube-logging/config-reloader:${DefaultFluentdConfigReloaderImageTag}
ghcr.io/axoflow/axosyslog:$syslogngImageTag
EOF
