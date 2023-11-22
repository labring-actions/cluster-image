## higress

```shell
wget https://github.com/labring/sealos/releases/download/v4.3.0/sealos_4.3.0_linux_amd64.tar.gz
tar -zxvf sealos_4.3.0_linux_amd64.tar.gz sealos
chmod a+x sealos 
mv sealos /usr/bin/
```

Under one sealos cluster, run the following command to deploy higress.
@Note: you must remove any other ingress controllers before you deploy higress.
 
```shell
sealos run --env HELM_OPTS="--set higress-core.gateway.replicas=3 --set higress-core.controller.replicas=3 \
  --set higress-console.replicaCount=0 --set higress-console.domain=higress-console.svc.cluster.local \
  --set higress-core.gateway.resources.requests.cpu=256m --set higress-core.gateway.resources.requests.memory=256Mi \
  --set higress-console.resources.requests.cpu=256m --set higress-console.resources.requests.memory=256Mi \
  --set higress-core.controller.resources.requests.cpu=256m --set higress-core.controller.resources.requests.memory=256Mi" \
  --env ENABLE_GATEWAY=true --env ENABLE_ISTIO=true --env APPLY_DEFAULT_CR=true \
  labring/higress:v1.3.1 
```

