#!/usr/bin/env bash
set -e

if [[ -z "$DOMAIN" ]]; then
    echo "Error: DOMAIN is not set or is empty. Exiting script."
    exit 1
fi

MINIO_EXTERNAL_ENDPOINT="https://objectstorageapi.${DOMAIN}"
CONSOLE_ACCESS_KEY=$(echo "$MINIO_ADMIN_USER" | base64)
CONSOLE_SECRET_KEY=$(echo "$MINIO_ADMIN_PASSWORD" | base64)

# create namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: objectstorage-system
EOF

# create env-configuration secret
MINIO_ROOT_USER=$(openssl rand -hex 12 | head -c 16)
MINIO_ROOT_PASSWORD=$(openssl rand -hex 24 | head -c 32)

CONFIG_ENV="export MINIO_STORAGE_CLASS_STANDARD=\"EC:2\"
export MINIO_BROWSER=\"on\"
export MINIO_ROOT_USER=\"$MINIO_ROOT_USER\"
export MINIO_ROOT_PASSWORD=\"$MINIO_ROOT_PASSWORD\""

ENCODED_CONFIG_ENV=$(echo "$CONFIG_ENV" | base64)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${MINIO_NAME}-env-configuration
  namespace: objectstorage-system
  labels:
    v1.min.io/tenant: ${MINIO_NAME}
data:
  config.env: >-
    $ENCODED_CONFIG_ENV
type: Opaque
EOF

# create ak/sk secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${MINIO_NAME}-secret
  namespace: objectstorage-system
  labels:
    v1.min.io/tenant: ${MINIO_NAME}
data:
  accesskey: ''
  secretkey: ''
type: Opaque
EOF

# create user-0 secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${MINIO_NAME}-user-0
  namespace: objectstorage-system
  labels:
    v1.min.io/tenant: ${MINIO_NAME}
immutable: true
data:
  CONSOLE_ACCESS_KEY: ${CONSOLE_ACCESS_KEY}
  CONSOLE_SECRET_KEY: ${CONSOLE_SECRET_KEY}
type: Opaque
EOF

# create tenant cr
cat <<EOF | kubectl apply -f -
apiVersion: minio.min.io/v2
kind: Tenant
metadata:
  name: ${MINIO_NAME}
  namespace: objectstorage-system
spec:
  configuration:
    name: ${MINIO_NAME}-env-configuration
  credsSecret:
    name: ${MINIO_NAME}-secret
  exposeServices:
    console: true
    minio: true
  features: {}
  image: minio/minio:RELEASE.2023-11-11T08-14-41Z
  imagePullSecret: {}
  mountPath: /export
  pools:
    - name: pool-0
      resources: {}
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
              storage: '$STORAGE_SIZE'
        status: {}
      volumesPerServer: 1
  requestAutoCert: false
  users:
    - name: ${MINIO_NAME}-user-0
scheduler:
  name: ''
EOF

# create service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: object-storage
  namespace: objectstorage-system
spec:
  ports:
    - name: http-minio
      protocol: TCP
      port: 80
      targetPort: 9000
  selector:
    v1.min.io/tenant: ${MINIO_NAME}
  type: LoadBalancer
  sessionAffinity: None
  externalTrafficPolicy: Cluster
  ipFamilies:
    - IPv4
  ipFamilyPolicy: SingleStack
  allocateLoadBalancerNodePorts: true
  internalTrafficPolicy: Cluster
EOF

# create api ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${MINIO_NAME}-api
  namespace: objectstorage-system
  labels:
    cloud.sealos.io/app-deploy-manager-domain: objectstorageapi
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
  name: ${MINIO_NAME}-console
  namespace: objectstorage-system
  labels:
    cloud.sealos.io/app-deploy-manager-domain: osconsole
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
                name: ${MINIO_NAME}-console
                port:
                  number: 9090
  tls:
    - hosts:
        - osconsole.${DOMAIN}
      secretName: wildcard-cert
EOF

curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc alias set objectstorage ${MINIO_EXTERNAL_ENDPOINT} ${MINIO_ADMIN_USER} ${MINIO_ADMIN_PASSWORD}

mc admin policy create objectstorage userNormal policy/user_deny_write.json
mc admin policy create objectstorage userDenyWrite policy/user_deny_write.json
mc admin policy create objectstorage migration policy/migration.json

mc admin user add objectstorage migration sealos.12345
mc admin group add objectstorage userNormal
mc admin group add objectstorage userDenyWrite
mc admin policy attach objectstorage migration --user migration
mc admin policy attach objectstorage userNormal --group userNormal
mc admin policy attach objectstorage userDenyWrite --group userDenyWrite