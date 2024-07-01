#!/usr/bin/env bash
set -e

NAME=${NAME:-"zabbix-server"}
NAMESPACE=${NAMESPACE:-"monitoring"}
CHARTS=${CHARTS:-"./charts/zabbix"}
HELM_OPTS=${HELM_OPTS:-" \
--set zabbixWeb.service.type=NodePort \
"}

helm upgrade -i ${NAME} ${CHARTS} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
