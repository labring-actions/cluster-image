#!/bin/bash
cp -rvf * /opt/containerd/
bash containerd.sh
kubectl apply -f runtime.yaml
