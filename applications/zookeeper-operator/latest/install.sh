#!/bin/bash

IP="${IP:-127.0.0.1}"
PORT="${PORT:-30080}"
OPERATOR_HELM_OPTS="${OPERATOR_HELM_OPTS:-}"
HELM_OPTS="${HELM_OPTS:-}"

helm upgrade --install zook-operator charts/zookeeper-operator --namespace zook-system --create-namespace  ${OPERATOR_HELM_OPTS}
helm upgrade --install zook charts/zookeeper --namespace zook-system --create-namespace  ${HELM_OPTS}
