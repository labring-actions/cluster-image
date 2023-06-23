#!/bin/bash
export readonly PUBLIC_IP="${1:-"127.0.0.1"}"
# shellcheck disable=SC2155
export readonly MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace mongodb-sharded mongodb-sharded -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
export readonly REDIS_PASSWORD=$(kubectl get secret --namespace "redis-cluster" redis-cluster -o jsonpath="{.data.redis-password}" | base64 -d)
export ISTIO_PORT=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath="{.spec.ports[1].nodePort}")

helm upgrade -i openim openIM --namespace openim-system --create-namespace \
  --set configmap.mongo.dbPassword="$MONGODB_ROOT_PASSWORD",configmap.redis.dbPassWord="$REDIS_PASSWORD",istio.publicPort="$ISTIO_PORT",istio.publicIP="$PUBLIC_IP"

