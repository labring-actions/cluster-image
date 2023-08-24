#!/bin/bash

HELM_OPTS="${HELM_OPTS:-}"

helm upgrade --install iomesh -n iomesh-system charts/iomesh --create-namespace --render-subchart-notes  ${HELM_OPTS}
