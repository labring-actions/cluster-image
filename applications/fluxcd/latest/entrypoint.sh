#!/usr/bin/env bash
set -e

NAMESPACE=${NAMESPACE:-"flux-system"}
VERSION=v2.1.2
FLUX_OPTS=${FLUX_OPTS:-" \
# install extra components
--components-extra=image-reflector-controller,image-automation-controller \
"}

cp -f opt/flux /usr/local/bin/
flux check --pre || { echo "flux check --pre failed"; exit 1; }
flux install -n ${NAMESPACE} -v ${VERSION} ${FLUX_OPTS}
