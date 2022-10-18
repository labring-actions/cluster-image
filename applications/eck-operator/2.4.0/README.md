## Build

```
sealos build -t labring/eck-operator/2.4.0 .
```

## Usage

Install, this will install eck-operator、elasticsearch、kibana and filebeat.

```
sealos run labring/eck-operator/2.4.0
```

Get pods status

```
root@node1:~# kubectl -n elastic-system  get pods 
NAME                           READY   STATUS    RESTARTS        AGE
elastic-operator-0             1/1     Running   1 (6m53s ago)   7m48s
elasticsearch-es-default-0     1/1     Running   0               6m48s
elasticsearch-es-default-1     1/1     Running   0               6m48s
elasticsearch-es-default-2     1/1     Running   0               6m48s
filebeat-beat-filebeat-kmb4b   1/1     Running   3 (6m9s ago)    6m45s
filebeat-beat-filebeat-v2spz   1/1     Running   3 (6m5s ago)    6m45s
kibana-kb-f64c457b4-blfkp      1/1     Running   0               6m45s
```

Elasticsearch and kibana have same username `elastic`  and password:

```
 kubectl -n elastic-system get secrets elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
```

Access kibana: 

```
https://<node-ip>:<nodeport>
```



