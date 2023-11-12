#!/bin/bash
cp -rvf bin /opt/containerd/
bash containerd.sh
kubectl apply -f runtime.yaml
