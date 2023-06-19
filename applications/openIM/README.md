## 如何安装OpenIM

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
  
  
  ** Please be patient while the chart is being deployed **
  
  MinIO&reg; can be accessed via port  on the following DNS name from within your cluster:
  
     bitnami-minio.minio.svc.cluster.local
  
  To get your credentials run:
  
     export ROOT_USER=$(kubectl get secret --namespace minio bitnami-minio -o jsonpath="{.data.root-user}" | base64 -d)
     export ROOT_PASSWORD=$(kubectl get secret --namespace minio bitnami-minio -o jsonpath="{.data.root-password}" | base64 -d)
  
  To connect to your MinIO&reg; server using a client:
  
  - Run a MinIO&reg; Client pod and append the desired command (e.g. 'admin info'):
  
     kubectl run --namespace minio bitnami-minio-client \
       --rm --tty -i --restart='Never' \
       --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
       --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
       --env MINIO_SERVER_HOST=bitnami-minio \
       --image docker.io/bitnami/minio-client:2023.5.18-debian-11-r2 -- admin info minio
  
  To access the MinIO&reg; web UI:
  
  - Get the MinIO&reg; URL:
  
     echo "MinIO&reg; web URL: http://127.0.0.1:9001/minio"
     kubectl port-forward --namespace minio svc/bitnami-minio 9001:9001
  
  ```


- bitnami-kafka

  ```shell
  sealos run labring/bitnami-kafka:v22.1.5
  
  
  ** Please be patient while the chart is being deployed **
  
  Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:
  
      bitnami-kafka.kafka.svc.cluster.local
  
  Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:
  
      bitnami-kafka-0.bitnami-kafka-headless.kafka.svc.cluster.local:9092
  
  To create a pod that you can use as a Kafka client run the following commands:
  
      kubectl run bitnami-kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.4.1-debian-11-r0 --namespace kafka --command -- sleep infinity
      kubectl exec --tty -i bitnami-kafka-client --namespace kafka -- bash
  
      PRODUCER:
          kafka-console-producer.sh \
              --broker-list bitnami-kafka-0.bitnami-kafka-headless.kafka.svc.cluster.local:9092 \
              --topic test
  
      CONSUMER:
          kafka-console-consumer.sh \
              --bootstrap-server bitnami-kafka.kafka.svc.cluster.local:9092 \
              --topic test \
              --from-beginning
  
  ```


- bitnami-mysql

  ```shell
  sealos run labring/bitnami-mysql:v9.10.4
  
  ** Please be patient while the chart is being deployed **
  
  Tip:
  
    Watch the deployment status using the command: kubectl get pods -w --namespace mysql
  
  Services:
  
    echo Primary: bitnami-mysql.mysql.svc.cluster.local:3306
  
  Execute the following to get the administrator credentials:
  
    echo Username: root
    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql bitnami-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
  
  To connect to your database:
  
    1. Run a pod that you can use as a client:
  
        kubectl run bitnami-mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.33-debian-11-r17 --namespace mysql --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
  
    2. To connect to primary service (read/write):
  
        mysql -h bitnami-mysql.mysql.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
  
  ```


- bitnami-zookeeper

  ```shell
  sealos run labring/bitnami-zookeeper:v11.4.2
  
  ** Please be patient while the chart is being deployed **
  
  ZooKeeper can be accessed via port 2181 on the following DNS name from within your cluster:
  
      bitnami-zookeeper.zookeeper.svc.cluster.local
  
  To connect to your ZooKeeper server run the following commands:
  
      export POD_NAME=$(kubectl get pods --namespace zookeeper -l "app.kubernetes.io/name=zookeeper,app.kubernetes.io/instance=bitnami-zookeeper,app.kubernetes.io/component=zookeeper" -o jsonpath="{.items[0].metadata.name}")
      kubectl exec -it $POD_NAME -- zkCli.sh
  
  To connect to your ZooKeeper server from outside the cluster execute the following commands:
  
      kubectl port-forward --namespace zookeeper svc/bitnami-zookeeper 2181:2181 &
      zkCli.sh 127.0.0.1:2181
  
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
