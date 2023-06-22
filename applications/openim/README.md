## 如何安装OpenIM

```shell
sealos run --masters 172.31.76.27 --nodes 172.31.76.28,172.31.76.29,172.31.76.30 labring/kubernetes:v1.25.6 labring/helm:v3.11.3 labring/calico:v3.24.1 --passwd 'Fanux#123'
sealos run labring/coredns:v0.0.1
sealos run labring/openebs:v3.4.0
sealos run labring/cert-manager:v1.12.1
sealos run labring/bitnami-kafka:v22.1.5
sealos run labring/bitnami-mysql:v9.10.4
sealos run labring/bitnami-mongodb-sharded:6.0.2
sealos run labring/bitnami-zookeeper:v11.4.2
sealos run labring/bitnami-redis-cluster:v8.4.4
sealos run labring/nginx:v1.24.0 -e NAME=nginx -e NAMESPACE=nginx -e HELM_OPTS="--set service.type=NodePort"
sealos run labring/bitnami-minio:v12.6.4
#需要获取密码
export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace mongodb-sharded mongodb-sharded -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
export REDIS_PASSWORD=$(kubectl get secret --namespace "redis-cluster" redis-cluster -o jsonpath="{.data.redis-password}" | base64 -d)
sealos run --cmd "helm upgrade -i openim openIM --namespace openim-system --create-namespace --set configmap.mongo.dbPassword=$MONGODB_ROOT_PASSWORD,configmap.redis.dbPassWord=$REDIS_PASSWORD" labring/openim:errcode
```

