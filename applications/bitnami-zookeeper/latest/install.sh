#!/bin/bash
HELM_OPTS="${HELM_OPTS:-}"
helm upgrade -i bitnami-zookeeper charts/zookeeper -n zookeeper --create-namespace ${HELM_OPTS}
