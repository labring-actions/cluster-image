
```
sealos run \
  --masters xxx --nodes xxx -p xxx \
  labring/kubernetes:v1.23.10 \
  labring/helm:v3.8.2 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/kuboard:v3
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
  labring/kuboard:v3 --single
  
kubectl taint nodes --all node-role.kubernetes.io/master-
```
3. print success info

```
2022-10-08T11:56:29 info guest cmd is bash kuboard.sh
namespace/kuboard created
configmap/kuboard-v3-etcd created
configmap/kuboard-v3-config created
serviceaccount/kuboard-boostrap created
clusterrolebinding.rbac.authorization.k8s.io/kuboard-boostrap-crb created
daemonset.apps/kuboard-etcd created
deployment.apps/kuboard-v3 created
service/kuboard-v3 created
configmap/kuboard-shell created
visit http://172.31.136.85:30080, user: admin password: Kuboard123
2022-10-08T11:56:29 info succeeded in creating a new cluster, enjoy it!
2022-10-08T11:56:29 info
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
root@iZj6c1eu1d5ulz81cqcc4uZ:~# crictl images
IMAGE                                       TAG                 IMAGE ID            SIZE
sealos.hub:5000/calico/cni                  v3.22.1             2a8ef6985a3e5       80.5MB
sealos.hub:5000/calico/node                 v3.22.1             7a71aca7b60fc       69.6MB
sealos.hub:5000/calico/pod2daemon-flexvol   v3.22.1             17300d20daf93       8.46MB
sealos.hub:5000/calico/typha                v3.22.1             f822f80398b9a       52.7MB
sealos.hub:5000/coredns/coredns             v1.8.6              a4ca41631cc7a       13.6MB
sealos.hub:5000/eipwork/etcd-host           3.4.16-2            d6066d124f666       53.1MB
sealos.hub:5000/etcd                        3.5.1-0             25f8c7f3da61c       98.9MB
sealos.hub:5000/kube-apiserver              v1.23.10            9ca5fafbe8dc1       32.6MB
sealos.hub:5000/kube-controller-manager     v1.23.10            91a4a0d5de4e9       30.2MB
sealos.hub:5000/kube-proxy                  v1.23.10            71b9bf9750e1f       39.3MB
sealos.hub:5000/kube-scheduler              v1.23.10            d5c0efb802d95       15.1MB
sealos.hub:5000/pause                       3.6                 6270bb605e12e       302kB
sealos.hub:5000/tigera/operator             v1.25.3             648350e58702c       44.8MB
```

5. list all pod
```
root@iZj6c1eu1d5ulz81cqcc4uZ:~# kubectl get pod -n kuboard
NAME                          READY   STATUS    RESTARTS   AGE
kuboard-etcd-v4flx            1/1     Running   0          52s
kuboard-v3-55fc4444c6-rlplr   1/1     Running   0          75s
```

## uninstall 


```
cd /var/lib/sealos/data/default/rootfs
kubectl delete -f manifests/kuboard-v3.yaml
kubectl delete -f manifests/kuboard-shell.yaml
sealos exec  "rm -rf /usr/share/kuboard"
```
