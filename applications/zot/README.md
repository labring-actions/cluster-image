### How to install

1. sealos run openebs
   docker.io/labring/openebs:v3.4.0
2. sealos run cert-manager
   docker.io/labring/cert-manager:v1.8.0
3. sealos run zot:v1.4.3
   docker.io/labring/zot:v1.4.3

### How to using
export PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export CLUSTER_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
echo "https://$CLUSTER_IP:$PORT"

helm registry  login  $CLUSTER_IP:$PORT --insecure  (admin:admin / user:user)
helm  push  zot-0.1.22.tgz  oci://$CLUSTER_IP:$PORT --insecure-skip-tls-verify
helm  pull  oci://$CLUSTER_IP:$PORT/zot --version 0.1.22 --insecure-skip-tls-verify=true

svc addr: zot.zot.svc.cluster.local:8443
