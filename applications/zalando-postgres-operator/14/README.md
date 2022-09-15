## Overview

Postgres operator creates and manages PostgreSQL clusters running in Kubernetes.

## Build

```shell
sealos build -f Dockerfile -t labring/postgres-operator:14 .
```

## Prerequisites

Postgres operator need a default storageclass, Here is an example of using openebs.

```
sealos run labring/openebs:v1.9.0
```

## Quickstart

Create a Postgres cluster.

```shell
sealos run labring/postgres-operator:14
```

Get postgress password from secrets.

```shell
kubectl -n postgres get secret postgres.acid-minimal-cluster.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
```

Connect to the Postgres cluster via psql.

```shell
root@node1:~# kubectl run -it --rm postgres --image=postgres:14-alpine -- sh
If you don't see a command prompt, try pressing enter.

/ # export PGPASSWORD=NsbiBmAoqpF0dL0yAIvM8BL7vGT88UcfCdR8Bxle0P4XjJCF9RMqLhVSjR1A6RNa
/ # psql -U postgres -h acid-minimal-cluster.postgres
psql (14.5, server 14.4 (Ubuntu 14.4-1.pgdg18.04+1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.


postgres=# \l
                                  List of databases
   Name    |   Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+-----------+----------+-------------+-------------+-----------------------
 bar       | bar_owner | UTF8     | en_US.utf-8 | en_US.utf-8 | 
 foo       | zalando   | UTF8     | en_US.utf-8 | en_US.utf-8 | 
 postgres  | postgres  | UTF8     | en_US.utf-8 | en_US.utf-8 | 
 template0 | postgres  | UTF8     | en_US.utf-8 | en_US.utf-8 | =c/postgres          +
           |           |          |             |             | postgres=CTc/postgres
 template1 | postgres  | UTF8     | en_US.utf-8 | en_US.utf-8 | =c/postgres          +
           |           |          |             |             | postgres=CTc/postgres
(5 rows)


postgres=# 
```
