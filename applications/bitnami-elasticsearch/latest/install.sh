#!/bin/bash
HELM_OPTS="${HELM_OPTS:-}"
helm upgrade -i bitnami-elasticsearch charts/elasticsearch -n elasticsearch --create-namespace ${HELM_OPTS}
