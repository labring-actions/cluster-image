#!/bin/bash
HELM_OPTS="${HELM_OPTS:-}"
helm upgrade -i bitnami-clickhouse charts/clickhouse -n clickhouse --create-namespace ${HELM_OPTS}
