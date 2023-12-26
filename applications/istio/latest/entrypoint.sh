#!/usr/bin/env bash
set -e

ISTIOCTL_OPTS=${ISTIOCTL_OPTS:-" \
--set profile=demo -y \
"}

cp -f opt/istioctl /usr/local/bin/
istioctl install ${ISTIOCTL_OPTS}
