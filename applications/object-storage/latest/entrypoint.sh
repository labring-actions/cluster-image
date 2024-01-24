#!/usr/bin/env bash
set -e

if [[ -z "$DOMAIN" ]]; then
    echo "Error: DOMAIN is empty. Exiting script."
    exit 1
fi

sealos run labring/minio-operator:v5.0.6 -e MINIO_OPERATOR_NAME=$MINIO_OPERATOR_NAME -e MINIO_OPERATOR_NAMESPACE=$MINIO_OPERATOR_NAMESPACE
sealos run labring/object-storage-minio:latest -e DOMAIN=$DOMAIN -e BACKEND_NAMESPACE=$BACKEND_NAMESPACE -e STORAGE_SIZE=$STORAGE_SIZE -e MINIO_ADMIN_USER=$MINIO_ADMIN_USER -e MINIO_ADMIN_PASSWORD=$MINIO_ADMIN_PASSWORD
sealos run labring/object-storage-controller:latest -e DOMAIN=$DOMAIN -e BACKEND_NAMESPACE=$BACKEND_NAMESPACE -e FRONTEND_NAMESPACE=$FRONTEND_NAMESPACE
sealos run labring/object-storage-monitor:latest -e DOMAIN=$DOMAIN -e BACKEND_NAMESPACE=$BACKEND_NAMESPACE
sealos run labring/object-storage-prometheus:latest -e BACKEND_NAMESPACE=$BACKEND_NAMESPACE -e STORAGE_SIZE=$STORAGE_SIZE

cat <<EOF | kubectl apply -f -
apiVersion: app.sealos.io/v1
kind: App
metadata:
  name: objectstorage
  namespace: app-system
spec:
  data:
    desc: object storage
    url: https://objectstorage.${DOMAIN}:443
  displayType: normal
  i18n:
    zh:
      name: 对象存储
    zh-Hans:
      name: 对象存储
  icon: https://objectstorage.${DOMAIN}:443/logo.svg
  menuData:
    helpDropDown: false
    nameColor: text-black
  name: Object Storage
  type: iframe
EOF