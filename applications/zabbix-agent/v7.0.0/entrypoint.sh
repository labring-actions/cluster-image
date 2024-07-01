#!/usr/bin/env bash
set -e

NAME=${NAME:-"zabbix-agent"}
NAMESPACE=${NAMESPACE:-"zabbix-monitoring"}
CHARTS=${CHARTS:-"./charts/zabbix-helm-chrt"}
HELM_OPTS=${HELM_OPTS:-""}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
