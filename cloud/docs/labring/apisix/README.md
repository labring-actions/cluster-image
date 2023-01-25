# APISIX

## Basic sealos cluster installation

Refer to [Cluster installation Kubernetes](https://www.sealos.io/docs/getting-started/kuberentes-life-cycle)

## How to install

Run a single command:

```bash
sealos run labring/apisix:2.15.1
```

We support `SERVICE_TYPE` and `GATEWAY_TLS` env.

```bash
sealos run labring/apisix:2.15.0 --env SERVICE_TYPE="LoadBalancer" --env GATEWAY_TLS="true"
```

## How to use

## Show status

```text
# kubectl get all -n ingress-apisix                                                                                                                                                                                          [9:09:48]
NAME                                             READY   STATUS    RESTARTS      AGE
pod/apisix-54699fc5c7-pkjfp                      1/1     Running   0             35m
pod/apisix-dashboard-7466f7f57f-nrlb8            1/1     Running   4 (34m ago)   35m
pod/apisix-etcd-0                                1/1     Running   0             35m
pod/apisix-etcd-1                                1/1     Running   0             35m
pod/apisix-etcd-2                                1/1     Running   0             35m
pod/apisix-ingress-controller-56dbffffc7-f828w   1/1     Running   0             35m

NAME                                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)             AGE
service/apisix-admin                ClusterIP   10.96.1.14    <none>        9180/TCP            35m
service/apisix-dashboard            NodePort    10.96.0.182   <none>        80:30569/TCP        35m
service/apisix-etcd                 ClusterIP   10.96.1.96    <none>        2379/TCP,2380/TCP   35m
service/apisix-etcd-headless        ClusterIP   None          <none>        2379/TCP,2380/TCP   35m
service/apisix-gateway              NodePort    10.96.1.224   <none>        80:31378/TCP        35m
service/apisix-ingress-controller   ClusterIP   10.96.2.252   <none>        80/TCP              35m

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/apisix                      1/1     1            1           35m
deployment.apps/apisix-dashboard            1/1     1            1           35m
deployment.apps/apisix-ingress-controller   1/1     1            1           35m

NAME                                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/apisix-54699fc5c7                      1         1         1       35m
replicaset.apps/apisix-dashboard-7466f7f57f            1         1         1       35m
replicaset.apps/apisix-ingress-controller-56dbffffc7   1         1         1       35m

NAME                           READY   AGE
statefulset.apps/apisix-etcd   3/3     35m
```

For more information, please visit [the official website](https://apisix.apache.org/)
