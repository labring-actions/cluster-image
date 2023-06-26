### How to install

1. sealos run openebs
   docker.io/labring/openebs:v3.4.0
2. sealos run cert-manager
   docker.io/labring/cert-manager:v1.8.0
3. sealos run zot:v1.4.3
   docker.io/labring/zot:v1.4.3

### How to using
export ZOT_PORT=$(kubectl get --namespace zot -o jsonpath="{.spec.ports[0].port}" services zot)
export ZOT_IP=$(kubectl get --namespace zot -o jsonpath="{.spec.clusterIP}" services zot)
echo "https://$ZOT_IP:$ZOT_PORT"

helm registry  login  $ZOT_IP:$ZOT_PORT --insecure  (admin:admin / user:user)
helm  push  zot-0.1.22.tgz  oci://$ZOT_IP:$ZOT_PORT --insecure-skip-tls-verify
helm  pull  oci://$ZOT_IP:$ZOT_PORT/zot --version 0.1.22 --insecure-skip-tls-verify=true

svc addr: zot.zot.svc.cluster.local:8443

### Using anonymousPolicy.yaml

sealos run --env policy=anonymousPolicy docker.io/labring/zot:v1.4.3
