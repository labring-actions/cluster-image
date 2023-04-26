#!/bin/bash

mkdir -p /root/.kube

cat > .kube/config <<EOF
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: $APISERVER
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: $USER_NAME
    namespace: $NAMESPACE
  name: $USER_NAME
current-context: $USER_NAME
kind: Config
preferences: {}
users:
- name: $USER_NAME
  user:
    token: $USER_TOKEN
EOF

if [ -e index.html ] 
then
    ttyd -p 8080 --index index.html  bash
else
    ttyd -p 8080 bash
fi