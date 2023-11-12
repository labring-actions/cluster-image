#!/bin/bash
cp -rvf * /opt/containerd/
cp /etc/containerd/config.toml /etc/containerd/config.toml.bak
sed -i 's/io.containerd.runc.v2/io.containerd.wasmedge.v1/g' /etc/containerd/config.toml
systemctl daemon-reload && systemctl restart containerd
