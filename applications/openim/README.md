## 如何安装OpenIM
- kubernetes
 ```shell
 sealos run --masters 172.31.76.28 --nodes 172.31.76.30,172.31.76.29,172.31.76.27 labring/kubernetes:v1.25.6 labring/helm:v3.11.3 labring/calico:v3.24.1 labring/coredns:v0.0.1
 ```

- openebs

  ```shell
  sealos run labring/openebs:v3.4.0
  ```

- cert-manager

  ```shell
  sealos run labring/cert-manager:v1.12.1
  ```

- bitnami-minio

  ```shell
  sealos run labring/bitnami-minio:v12.6.4
  ```


- bitnami-kafka

  ```shell
  sealos run labring/bitnami-kafka:v22.1.5
  kubectl apply -f kafka.yaml
  
  ```


- bitnami-mysql

  ```shell
  sealos run labring/bitnami-mysql:v9.10.4
  ```
- bitnami-mongo/mongo-singele

  sealos run labring/bitnami-mongodb-sharded:6.0.2
  sealos run labring/bitnami-mongodb:6.0.2
  sealos run labring/mongodb-community-operator:0.7.6
  sealos run labring/mongodb-single:6.0.6 (support arm)

- bitnami-zookeeper

  ```shell
  sealos run labring/bitnami-zookeeper:v11.4.2
  ```
- redis:v8.4.4
  
  ```shell
  sealos run labring/bitnami-redis-cluster:v8.4.4
  ```

- nginx:v1.24.0

  ```shell
  sealos run docker.io/labring/nginx:v1.24.0 -e NAME=nginx -e NAMESPACE=nginx -e HELM_OPTS="--set service.type=NodePort"
  
  
  ** Please be patient while the chart is being deployed **
  NGINX can be accessed through the following DNS name from within your cluster:
  
      nginx.nginx.svc.cluster.local (port 80)
  
  To access NGINX from outside the cluster, follow the steps below:
  
  1. Get the NGINX URL by running these commands:
  
      export NODE_PORT=$(kubectl get --namespace nginx -o jsonpath="{.spec.ports[0].nodePort}" services nginx)
      export NODE_IP=$(kubectl get nodes --namespace nginx -o jsonpath="{.items[0].status.addresses[0].address}")
      echo "http://${NODE_IP}:${NODE_PORT}"
  ```

- openim:errcode
  ```shell
    sealos run --env password_valuespath=/root/values.yaml docker.io/labring/openim:errcode
  ```
