
```
sealos run \
  --masters xxx --nodes xxx -p xxx \
  labring/kubernetes:v1.23.10 \
  labring/helm:v3.8.2 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/kuboard:v2
```


## how to use

Start kubegems with one click:
1. install sealos
```
wget https://github.com/labring/sealos/releases/download/v4.1.3/sealos_4.1.3_linux_amd64.tar.gz \
   && tar zxvf sealos_4.1.3_linux_amd64.tar.gz sealos && chmod +x sealos && mv sealos /usr/bin
```
2. install kuboard with k8s
```
sealos run \
  labring/kubernetes:v1.23.10 \
  labring/helm:v3.8.2 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/kuboard:v2 --single
  
kubectl taint nodes --all node-role.kubernetes.io/master-
```
3. print success info

```
2022-10-10T14:43:10 info guest cmd is bash kuboard.sh
namespace/kuboard-v2 created
deployment.apps/kuboard created
service/kuboard created
serviceaccount/kuboard-user created
clusterrolebinding.rbac.authorization.k8s.io/kuboard-user created
serviceaccount/kuboard-viewer created
clusterrolebinding.rbac.authorization.k8s.io/kuboard-viewer created
Visit Kuboard v2 : http://172.31.159.216:32567, token: eyJhbGciOiJSUzI1NiIsImtpZCI6IlNEeFBIckV0TFZlTGJGQUNTU042TXZBUjR2VC1LcXA5XzFqdUxQd0thU0kifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJvYXJkLXYyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Imt1Ym9hcmQtdXNlci10b2tlbi1jNGs0biIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJvYXJkLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJhNDRlMTAyZi04NGMwLTQ0ZDUtYjE5Yi0xMWViOGJkMjI0MzEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3Vib2FyZC12MjprdWJvYXJkLXVzZXIifQ.PoEAvZQfqE6lg3WV_CPEAPGwIalpSTO5_81tcH7kFBbcJHFCQdlWeLzBULC9sKOYQxATkrr_k4np1QRT6c2lXy88pLsgu6ITMJWr1_h_DVeQ6I4GcMI1_EG0T4PViYqOKOBce6u9gY2p7quwzxOCcolUQeY1pK04_JYTdCcwb9SzP6Ph6gCqBkmnJTysC5aV_wUelK326lSgfscN47y9tkIZ6t0kEgdsKKAXkM_ijJHynYn7ddBeuz7GqV8RBf4RwrR2MrQ-47WgGVrZ0oNFa4qcUy76Dlm-yM-xzMzJJu6kE1A_n7GI_0EuTfoh5AoTFXR8fRNb2lxyRSfbAVhJqw
2022-10-10T14:43:11 info succeeded in creating a new cluster, enjoy it!
2022-10-10T14:43:11 info
      ___           ___           ___           ___       ___           ___
     /\  \         /\  \         /\  \         /\__\     /\  \         /\  \
    /::\  \       /::\  \       /::\  \       /:/  /    /::\  \       /::\  \
   /:/\ \  \     /:/\:\  \     /:/\:\  \     /:/  /    /:/\:\  \     /:/\ \  \
  _\:\~\ \  \   /::\~\:\  \   /::\~\:\  \   /:/  /    /:/  \:\  \   _\:\~\ \  \
 /\ \:\ \ \__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/__/    /:/__/ \:\__\ /\ \:\ \ \__\
 \:\ \:\ \/__/ \:\~\:\ \/__/ \/__\:\/:/  / \:\  \    \:\  \ /:/  / \:\ \:\ \/__/
  \:\ \:\__\    \:\ \:\__\        \::/  /   \:\  \    \:\  /:/  /   \:\ \:\__\
   \:\/:/  /     \:\ \/__/        /:/  /     \:\  \    \:\/:/  /     \:\/:/  /
    \::/  /       \:\__\         /:/  /       \:\__\    \::/  /       \::/  /
     \/__/         \/__/         \/__/         \/__/     \/__/         \/__/

                  Website :https://www.sealos.io/
                  Address :github.com/labring/sealos
```

4. print offline image
```
sealos.hub:5000/calico/cni                  v3.22.1             2a8ef6985a3e5       80.5MB
sealos.hub:5000/calico/kube-controllers     v3.22.1             c0c6672a66a59       54.9MB
sealos.hub:5000/calico/node                 v3.22.1             7a71aca7b60fc       69.6MB
sealos.hub:5000/calico/pod2daemon-flexvol   v3.22.1             17300d20daf93       8.46MB
sealos.hub:5000/calico/typha                v3.22.1             f822f80398b9a       52.7MB
sealos.hub:5000/coredns/coredns             v1.8.6              a4ca41631cc7a       13.6MB
sealos.hub:5000/etcd                        3.5.1-0             25f8c7f3da61c       98.9MB
sealos.hub:5000/kube-apiserver              v1.23.10            9ca5fafbe8dc1       32.6MB
sealos.hub:5000/kube-controller-manager     v1.23.10            91a4a0d5de4e9       30.2MB
sealos.hub:5000/kube-proxy                  v1.23.10            71b9bf9750e1f       39.3MB
sealos.hub:5000/kube-scheduler              v1.23.10            d5c0efb802d95       15.1MB
sealos.hub:5000/labring/docker-kuboard      v2                  a1a5060fe43dc       72.4MB
sealos.hub:5000/pause                       3.6                 6270bb605e12e       302kB
sealos.hub:5000/tigera/operator             v1.25.3             648350e58702c       44.8MB
```

5. list all resource
```
root@iZj6ci63a7sdqwqkg1mswwZ:~# kubectl get all -n kuboard-v2
NAME                           READY   STATUS    RESTARTS   AGE
pod/kuboard-699dcd587c-q9vr7   1/1     Running   0          3m14s

NAME              TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
service/kuboard   NodePort   10.96.2.126   <none>        80:32567/TCP   3m23s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kuboard   1/1     1            1           3m23s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/kuboard-699dcd587c   1         1         1       3m15s
```

## uninstall


```
cd /var/lib/sealos/data/default/rootfs
kubectl delete -f manifests/kuboard-v2.yaml
```
