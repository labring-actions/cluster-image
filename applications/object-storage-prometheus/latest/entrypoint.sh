#!/usr/bin/env bash
set -e

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: object-storage-sa
  namespace: ${BACKEND_NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: object-storage-role
  namespace: ${BACKEND_NAMESPACE}
rules:
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - ''
    resources:
      - secrets
  - verbs:
      - create
      - delete
      - get
    apiGroups:
      - ''
    resources:
      - services
  - verbs:
      - get
      - list
      - watch
    apiGroups:
      - minio.min.io
    resources:
      - tenants
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: object-storage-rolebind
  namespace: ${BACKEND_NAMESPACE}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: object-storage-role
  namespace: ${BACKEND_NAMESPACE}
subjects:
  - kind: ServiceAccount
    name: object-storage-sa
    namespace: ${BACKEND_NAMESPACE}
---
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  labels:
    app: prometheus-object-storage
  name: object-storage
  namespace: ${BACKEND_NAMESPACE}
spec:
  podMetadata:
    labels:
      app: prometheus-object-storage
  resources:
    limits:
      cpu: 200m
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 128Mi
  securityContext:
    fsGroup: 2000
    runAsGroup: 2000
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
  evaluationInterval: 60s
  image: quay.io/prometheus/prometheus:v2.45.0
  serviceMonitorSelector: {}
  probeSelector: {}
  ruleSelector: {}
  portName: http-web
  retention: 10d
  scrapeInterval: 60s
  serviceAccountName: object-storage-sa
  replicas: 1
  shards: 1
  storage:
    volumeClaimTemplate:
      metadata:
        annotations:
          path: /prometheus
          value: ${STORAGE_SIZE}Gi
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: ${STORAGE_SIZE}Gi
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-object-storage
  namespace: ${BACKEND_NAMESPACE}
spec:
  ports:
    - port: 9090
      targetPort: 9090
      protocol: TCP
      name: http-web
  selector:
    app: prometheus-object-storage
  type: ClusterIP
EOF