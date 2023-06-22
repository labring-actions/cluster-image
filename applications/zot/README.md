### How to install

1. sealos run openebs
   docker.io/labring/openebs:v3.4.0
2. sealos run cert-manager
   docker.io/labring/cert-manager:v1.8.0
3. sealos run zot:v1.4.3
   docker.io/labring/zot:v1.4.3

### How to using
export NODE_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].nodePort}" services zot)
export NODE_IP=$(kubectl get nodes --namespace zot -o jsonpath="{.items[0].status.addresses[0].address}")
echo "https://$NODE_IP:$NODE_PORT"

helm registry  login  $NODE_IP:$NODE_PORT --insecure  (admin:admin / user:user)
helm  push  zot-0.1.22.tgz  oci://$NODE_IP:$NODE_PORT --insecure-skip-tls-verify
helm  pull  oci://$NODE_IP:$NODE_PORT/zot --version 0.1.22 --insecure-skip-tls-verify=true
