## Overview

Elastic Cloud on Kubernetes automates the deployment, provisioning, management, and orchestration of Elasticsearch, Kibana, APM Server, Enterprise Search, Beats, Elastic Agent, and Elastic Maps Server on Kubernetes based on the operator pattern.

## Install

```
sealos run labring/eck-operator:v2.6.1
```

Get pods status

```
root@node1:~# kubectl -n elastic-system get pods 
NAME                           READY   STATUS    RESTARTS        AGE
elastic-operator-0             1/1     Running   0               7m3s
elasticsearch-es-default-0     1/1     Running   0               6m39s
elasticsearch-es-default-1     1/1     Running   0               6m39s
elasticsearch-es-default-2     1/1     Running   0               6m39s
filebeat-beat-filebeat-x964r   1/1     Running   4 (5m27s ago)   6m37s
kibana-kb-5996f64894-265kj     1/1     Running   0               6m37s
```

Get service status

```
root@node1:~# kubectl -n elastic-system get svc
NAME                             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
elastic-operator-webhook         ClusterIP   10.96.3.123   <none>        443/TCP          7m6s
elasticsearch-es-default         ClusterIP   None          <none>        9200/TCP         6m42s
elasticsearch-es-http            ClusterIP   10.96.0.208   <none>        9200/TCP         6m43s
elasticsearch-es-internal-http   ClusterIP   10.96.3.51    <none>        9200/TCP         6m43s
elasticsearch-es-transport       ClusterIP   None          <none>        9300/TCP         6m43s
kibana-kb-http                   NodePort    10.96.0.152   <none>        5601:32522/TCP   6m42s
```

Get password

```
kubectl -n elastic-system get secrets elasticsearch-es-elastic-user \
  -o=jsonpath='{.data.elastic}' | base64 --decode
```

Login kibana with default user `elastic`

```
https://<node-ip>:<node-port>
```

