#!/usr/bin/env bash
set -e

# check controller minio monitor prometheus

# app cr
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