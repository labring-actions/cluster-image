#!/bin/bash

echo "[1]set kubeconfig"
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
CA_CRT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

kubectl config set-cluster default-cluster --server=https://${KUBERNETES_SERVICE_HOST} --certificate-authority=${CA_CRT} --embed-certs=true
kubectl config set-credentials default-admin --token=${TOKEN}
kubectl config set-context default-system --cluster=default-cluster --user=default-admin
kubectl config use-context default-system

echo "[2]enable kubernetes provider"
hal config provider kubernetes enable

echo "[3]create account"
if ! hal config provider kubernetes account get spinnaker-admin -q &>/dev/null; then
    hal config provider kubernetes account add spinnaker-admin --context $(kubectl config current-context)
fi

echo "[4]set deploy type"
hal config deploy edit --type distributed --account-name spinnaker-admin

echo "[5]override base url"
hal config security ui edit --override-base-url http://${DOMAIN}
hal config security api edit --override-base-url http://${DOMAIN}/api/v1
mkdir -p /home/spinnaker/.hal/default/profiles
cat >/home/spinnaker/.hal/default/profiles/gate-local.yml<<EOF
server:
  servlet:
    context-path: /api/v1
EOF

mkdir -p /home/spinnaker/.hal/default/service-settings
cat >/home/spinnaker/.hal/default/service-settings/gate.yml<<EOF
healthEndpoint: /api/v1/health
EOF

echo "[6]set timezone"
hal config edit --timezone Asia/Shanghai

echo "[7]set s3 storage"
DEPLOYMENT=default
mkdir -p ~/.hal/$DEPLOYMENT/profiles
echo "spinnaker.s3.versioning: false" > ~/.hal/$DEPLOYMENT/profiles/front50-local.yml

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $ENDPOINT \
    --bucket spinnaker --path-style-access=true \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key --no-validate
hal config storage edit --type s3

echo "[8]set spinnaker version"
hal config version edit --version local:${spinnaker_version}

echo "[9]deploy spinnaker"
hal deploy apply
