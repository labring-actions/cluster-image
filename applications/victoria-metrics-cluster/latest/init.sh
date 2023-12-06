#!/bin/bash
set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts
mkdir charts

default_values_yaml="charts/default_values.yaml"
touch $default_values_yaml
tee $default_values_yaml << EOF
vminsert:
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8480"
  replicaCount: 1
  service:
    type: LoadBalancer

  tolerations:
    - key: kubeblocks-cloud
      operator: Equal
      value: "true"
      effect: NoSchedule
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
              - key: kubeblocks-cloud
                operator: In
                values:
                  - "true"

vmselect:
  extraArgs:
    dedup.minScrapeInterval: 1s
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8481"
  replicaCount: 1

  tolerations:
    - key: kubeblocks-cloud
      operator: Equal
      value: "true"
      effect: NoSchedule
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
              - key: kubeblocks-cloud
                operator: In
                values:
                  - "true"

vmstorage:
  extraArgs:
    retentionPeriod: "168h"
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8482"
  replicaCount: 1
  persistentVolume:
    enabled: true
    size: 10Gi
    accessModes:
      - ReadWriteOnce
    annotations: {}

  tolerations:
    - key: kubeblocks-cloud
      operator: Equal
      value: "true"
      effect: NoSchedule
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
              - key: kubeblocks-cloud
                operator: In
                values:
                  - "true"
EOF

repo_url="https://github.com/apecloud/helm-charts/releases/download"
charts=("victoria-metrics-cluster")
for chart in "${charts[@]}"; do
    helm fetch -d charts --untar "$repo_url"/"${chart}"-"${VERSION#v}"/"${chart}"-"${VERSION#v}".tgz
    rm -rf charts/"${chart}"-"${VERSION#v}".tgz
done
