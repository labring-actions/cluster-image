## Build

```
sealos build -t labring/elastic:7.17.3  .
```

## Usage

Install elasticsearch and kibanna.

```
sealos run labring/elastic:7.17.3
```

Install fluent-bit

```
sealos run labring/fluent-operator-containerd:v1.5.1
```

Get pods status

```
root@node1:~# kubectl -n elastic get pods
NAME                               READY   STATUS    RESTARTS   AGE
elasticsearch-master-0             1/1     Running   0          95m
elasticsearch-master-1             1/1     Running   0          95m
elasticsearch-master-2             1/1     Running   0          95m
fluent-bit-lkntx                   1/1     Running   0          16m
fluent-bit-lkrhv                   1/1     Running   0          16m
fluent-bit-ttkms                   1/1     Running   0          16m
fluent-operator-8456d9fbd8-kjtvq   1/1     Running   0          16m
kibana-kibana-95dc995b9-r5q86      1/1     Running   0          95m
```

Access kibana dashboard and then go to `Management`--> `Stack Management` add index.

```
https://<node-ip>:<nodeport>
```
