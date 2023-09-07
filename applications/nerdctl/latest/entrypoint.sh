#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

systemctl stop buildkit.socket >/dev/null 2>&1 || true
mkdir -p /etc/buildkit
cp -f ./etc/buildkit.service /etc/systemd/system/buildkit.service
cp -f ./etc/buildkit.socket /etc/systemd/system/buildkit.socket
cp -f ./etc/buildkitd.toml /etc/buildkit/buildkitd.toml
cp -f ./opt /usr/local/bin
systemctl enable --now buildkit
