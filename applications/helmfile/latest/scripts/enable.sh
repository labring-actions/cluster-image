#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

sealos scp -r master ../opt/helm /usr/bin/helm
sealos scp -r master ../opt/helmfile /usr/bin/helmfile
sealos exec -r master "mkdir -p /root/.local/share/helm/plugins/helm-diff"
sealos scp -r master ../opt/diff /root/.local/share/helm/plugins/helm-diff
