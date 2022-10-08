### 

#### How to use it 

```shell
sealos run  labring/oracle-mysql-operator:8.0.30-2.0.6
```

#### How to update values

edit values file 

vim /var/lib/sealos/data/default/rootfs/values/oracle-mysql-cluster-values.yaml


```shell
cd /var/lib/sealos/data/default/rootfs
helm delete mysql-mycluster -n mysql-operator
helm upgrade -f /root/values.yaml --install mysql-mycluster  charts/mysql-innodbcluster --namespace=mysql-operator --create-namespace
```


#### Connecting to MySQL InnoDB Cluster

A MySQL InnoDB Cluster `Service` is created inside the Kubernetes cluster:

```sh
$> kubectl get service mysql-mycluster -n mysql-operator

NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                  AGE
mysql-mycluster   ClusterIP   10.110.228.51   <none>        3306/TCP,33060/TCP,6446/TCP,6448/TCP,6447/TCP,6449/TCP   26h
```

The ports represent read-write and read-only ports for the MySQL Protocol and the X Protocol.
Use `describe` or see the documentation for additional information.

### Using MySQL Shell

This example creates a new container named `myshell` using the `mysql/mysql-operator` image (which is used because
it contains MySQL Shell; other images such as `mysql/mysql-server:8.0` work too), and immediately executes MySQL Shell:

```sh
$> kubectl run --rm -it myshell --image=mysql/mysql-operator -n mysql-operator -- mysqlsh
If you don't see a command prompt, try pressing enter.

MySQL JS>  \connect root@mysql-mycluster

Creating a session to 'root@mysql-mycluster'
Please provide the password for 'root@mysql-mycluster': ******

MySQL mysql-mycluster JS>
```

Using `root@mysql-mycluster` connection assumes the default namespace is used; the long form is `{innodbclustername}.{namespace}.svc.cluster.local`.
Each MySQL instance has MySQL Shell installed that can be used when troubleshooting.

### Using Port Forwarding

Kubernetes port forwarding creates a redirection from your local machine to use a MySQL client, such as `mysql` or MySQL Workbench.
For example, for read-write connection to the primary using the MySQL protocol:

```sh
$> kubectl port-forward  -n mysql-operator service/mysql-mycluster  mysql

Forwarding from 127.0.0.1:3306 -> 6446
Forwarding from [::1]:3306 -> 6446
```

And in a second terminal:

```sh
$> mysql -h127.0.0.1 -P3306 -uroot -p

Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
...
```
