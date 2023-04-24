#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

NAME=${NAME:-"sriov-network-operator"}
NAMESPACE=${NAMESPACE:-"sriov-network-operator"}

helm upgrade -i ${NAME} ../charts/sriov-network-operator -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
