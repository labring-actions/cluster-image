#!/usr/bin/env bash
set -e

if [[ -z "${DOMAIN}" ]]; then
    echo "Error: DOMAIN is empty. Exiting script."
    exit 1
fi

MINIO_EXTERNAL_ENDPOINT="https://objectstorageapi.${DOMAIN}"
CONSOLE_ACCESS_KEY=$(echo -n "${MINIO_ADMIN_USER}" | base64 -w 0)
CONSOLE_SECRET_KEY=$(echo -n "${MINIO_ADMIN_PASSWORD}" | base64 -w 0)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${BACKEND_NAMESPACE}
EOF

MINIO_ROOT_USER=$(openssl rand -hex 12 | head -c 16)
MINIO_ROOT_PASSWORD=$(openssl rand -hex 24 | head -c 32)

CONFIG_ENV="export MINIO_STORAGE_CLASS_STANDARD=\"EC:2\"
export MINIO_BROWSER=\"on\"
export MINIO_ROOT_USER=\"${MINIO_ROOT_USER}\"
export MINIO_ROOT_PASSWORD=\"${MINIO_ROOT_PASSWORD}\""

ENCODED_CONFIG_ENV=$(echo -n "$CONFIG_ENV" | base64 -w 0)

if kubectl get secret object-storage-env-configuration -n ${BACKEND_NAMESPACE} 2>&1 | grep -q "not found"; then
 cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: object-storage-env-configuration
  namespace: ${BACKEND_NAMESPACE}
  labels:
    v1.min.io/tenant: object-storage
data:
  config.env: >-
    ${ENCODED_CONFIG_ENV}
type: Opaque
EOF
fi

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: object-storage-secret
  namespace: ${BACKEND_NAMESPACE}
  labels:
    v1.min.io/tenant: object-storage
data:
  accesskey: ''
  secretkey: ''
type: Opaque
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: object-storage-user-0
  namespace: ${BACKEND_NAMESPACE}
  labels:
    v1.min.io/tenant: object-storage
immutable: true
data:
  CONSOLE_ACCESS_KEY: ${CONSOLE_ACCESS_KEY}
  CONSOLE_SECRET_KEY: ${CONSOLE_SECRET_KEY}
type: Opaque
EOF

cat <<EOF | kubectl apply -f -
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: object-storage
  namespace: ${BACKEND_NAMESPACE}
spec:
  configuration:
    name: object-storage-env-configuration
  credsSecret:
    name: object-storage-secret
  exposeServices:
    console: true
    minio: true
  features: {}
  image: minio/minio:RELEASE.2023-11-11T08-14-41Z
  imagePullSecret: {}
  mountPath: /export
  pools:
    - name: pool-0
      resources:
        limits:
          cpu: 1000m
          memory: 2Gi
        requests:
          cpu: 100m
          memory: 256Mi
      runtimeClassName: ''
      servers: 4
      volumeClaimTemplate:
        metadata:
          name: data
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: ${STORAGE_SIZE}Gi
        status: {}
      volumesPerServer: 1
  requestAutoCert: false
  users:
    - name: object-storage-user-0
scheduler:
  name: ''
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: object-storage
  namespace: ${BACKEND_NAMESPACE}
spec:
  ports:
    - name: http-minio
      protocol: TCP
      port: 80
      targetPort: 9000
  selector:
    v1.min.io/tenant: object-storage
  type: LoadBalancer
  sessionAffinity: None
  externalTrafficPolicy: Cluster
  ipFamilies:
    - IPv4
  ipFamilyPolicy: SingleStack
  allocateLoadBalancerNodePorts: true
  internalTrafficPolicy: Cluster
EOF

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: object-storage-api
  namespace: ${BACKEND_NAMESPACE}
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-body-size: 3g
    nginx.ingress.kubernetes.io/server-snippet: |
      client_header_buffer_size 64k;
      large_client_header_buffers 4 128k;
    nginx.ingress.kubernetes.io/ssl-redirect: 'false'
    nginx.ingress.kubernetes.io/backend-protocol: HTTP
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
    nginx.ingress.kubernetes.io/client-body-buffer-size: 64k
    nginx.ingress.kubernetes.io/proxy-buffer-size: 64k
    nginx.ingress.kubernetes.io/configuration-snippet: |
      if (\$request_uri ~* \.(js|css|gif|jpe?g|png)) {
        expires 30d;
        add_header Cache-Control "public";
      }
spec:
  rules:
    - host: objectstorageapi.${DOMAIN}
      http:
        paths:
          - pathType: Prefix
            path: /()(.*)
            backend:
              service:
                name: object-storage
                port:
                  number: 80
  tls:
    - hosts:
        - objectstorageapi.${DOMAIN}
      secretName: wildcard-cert
EOF

# create console ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: object-storage-console
  namespace: ${BACKEND_NAMESPACE}
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-body-size: 3g
    nginx.ingress.kubernetes.io/server-snippet: |
      client_header_buffer_size 64k;
      large_client_header_buffers 4 128k;
    nginx.ingress.kubernetes.io/ssl-redirect: 'false'
    nginx.ingress.kubernetes.io/backend-protocol: HTTP
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
    nginx.ingress.kubernetes.io/client-body-buffer-size: 64k
    nginx.ingress.kubernetes.io/proxy-buffer-size: 64k
    nginx.ingress.kubernetes.io/configuration-snippet: |
      if (\$request_uri ~* \.(js|css|gif|jpe?g|png)) {
        expires 30d;
        add_header Cache-Control "public";
      }
spec:
  rules:
    - host: osconsole.${DOMAIN}
      http:
        paths:
          - pathType: Prefix
            path: /()(.*)
            backend:
              service:
                name: object-storage-console
                port:
                  number: 9090
  tls:
    - hosts:
        - osconsole.${DOMAIN}
      secretName: wildcard-cert
EOF

if [ ! -f "$HOME/minio-binaries/mc" ]; then
  curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
fi

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

while kubectl wait -l statefulset.kubernetes.io/pod-name=object-storage-pool-0-0 --for=condition=ready pod -n ${BACKEND_NAMESPACE} --timeout=-1s 2>&1 | grep -q "error: no matching resources found"; do
  sleep 1
done

kubectl wait -l statefulset.kubernetes.io/pod-name=object-storage-pool-0-0 --for=condition=ready pod -n ${BACKEND_NAMESPACE} --timeout=-1s
kubectl wait -l statefulset.kubernetes.io/pod-name=object-storage-pool-0-1 --for=condition=ready pod -n ${BACKEND_NAMESPACE} --timeout=-1s
kubectl wait -l statefulset.kubernetes.io/pod-name=object-storage-pool-0-2 --for=condition=ready pod -n ${BACKEND_NAMESPACE} --timeout=-1s
kubectl wait -l statefulset.kubernetes.io/pod-name=object-storage-pool-0-3 --for=condition=ready pod -n ${BACKEND_NAMESPACE} --timeout=-1s

while mc alias set objectstorage ${MINIO_EXTERNAL_ENDPOINT} ${MINIO_ADMIN_USER} ${MINIO_ADMIN_PASSWORD} 2>&1 | grep -q "Unable to initialize new alias from the provided credentials."; do
  sleep 1
done

mc admin policy create objectstorage userNormal ./manifests/policy/user_normal.json
mc admin policy create objectstorage userDenyWrite ./manifests/policy/user_deny_write.json
mc admin policy create objectstorage migration ./manifests/policy/migration.json

mc admin user add objectstorage migration sealos.12345
mc admin user add objectstorage testuser sealos2023
mc admin group add objectstorage userNormal testuser
mc admin group add objectstorage userDenyWrite testuser

mc admin policy attach objectstorage userNormal --group userNormal
mc admin policy attach objectstorage userDenyWrite --group userDenyWrite
mc admin policy attach objectstorage migration --user migration