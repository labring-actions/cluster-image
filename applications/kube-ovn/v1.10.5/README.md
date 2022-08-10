### Build

Build command

```shell
sealos build -f Dockerfile -t docker.io/labring/kube-ovn:v1.10.5 .
```

## Usage

1.Run kube-ovn kubernetes ,net interface is "eth.*,en.*"

```shell
sealos run labring/kubernetes:v1.24.3 labring/kube-ovn:v1.10.5 --masters xxxx --nodes xxxxx
```

2.Run kube-ovn kubernetes , change default IFACE

```shell
sealos run labring/kubernetes:v1.24.3 labring/kube-ovn:v1.10.5 -e IFACE=enp6s0f0,eth.* --masters xxxx --nodes xxxxx
```

## Running Loggers

```
-------------------------------
Kube-OVN Version:     v1.10.5
Default Network Mode: geneve
Default Subnet CIDR:  100.64.0.0/10
Join Subnet CIDR:     20.65.0.0/16
Enable SVC LB:        false
Enable Networkpolicy: true
Enable EIP and SNAT:  true
Enable Mirror:        false
-------------------------------
[Step 1/6] Label kube-ovn-master node and label datapath type
node/sealos-master0 labeled
-------------------------------

[Step 2/6] Install OVN components
Install OVN DB in 192.168.64.24,
customresourcedefinition.apiextensions.k8s.io/vpc-nat-gateways.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-eips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-fip-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-dnat-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/iptables-snat-rules.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vpcs.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/ips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vips.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/subnets.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/vlans.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/provider-networks.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/security-groups.kubeovn.io created
customresourcedefinition.apiextensions.k8s.io/htbqoses.kubeovn.io created
serviceaccount/ovn created
clusterrole.rbac.authorization.k8s.io/system:ovn created
clusterrolebinding.rbac.authorization.k8s.io/ovn created
service/ovn-nb created
service/ovn-sb created
service/ovn-northd created
deployment.apps/ovn-central created
daemonset.apps/ovs-ovn created
Waiting for deployment "ovn-central" rollout to finish: 0 of 1 updated replicas are available...
deployment "ovn-central" successfully rolled out
-------------------------------

[Step 3/6] Install Kube-OVN
deployment.apps/kube-ovn-controller created
daemonset.apps/kube-ovn-cni created
daemonset.apps/kube-ovn-pinger created
deployment.apps/kube-ovn-monitor created
service/kube-ovn-monitor created
service/kube-ovn-pinger created
service/kube-ovn-controller created
service/kube-ovn-cni created
Waiting for deployment "kube-ovn-controller" rollout to finish: 0 of 1 updated replicas are available...
deployment "kube-ovn-controller" successfully rolled out
Waiting for daemon set "kube-ovn-cni" rollout to finish: 0 of 3 updated pods are available...
Waiting for daemon set "kube-ovn-cni" rollout to finish: 1 of 3 updated pods are available...
Waiting for daemon set "kube-ovn-cni" rollout to finish: 2 of 3 updated pods are available...
daemon set "kube-ovn-cni" successfully rolled out
-------------------------------

[Step 4/6] Delete pod that not in host network mode
pod "coredns-6d4b75cb6d-8rjhf" deleted
pod "coredns-6d4b75cb6d-bzfjv" deleted
pod "kube-ovn-pinger-lm7pb" deleted
pod "kube-ovn-pinger-xgrpd" deleted
daemon set "kube-ovn-pinger" successfully rolled out
deployment "coredns" successfully rolled out
-------------------------------

[Step 5/6] Install kubectl plugin
-------------------------------

[Step 6/6] Finish

                    ,,,,
                    ,::,
                   ,,::,,,,
            ,,,,,::::::::::::,,,,,
         ,,,::::::::::::::::::::::,,,
       ,,::::::::::::::::::::::::::::,,
     ,,::::::::::::::::::::::::::::::::,,
    ,::::::::::::::::::::::::::::::::::::,
   ,:::::::::::::,,   ,,:::::,,,::::::::::,
 ,,:::::::::::::,       ,::,     ,:::::::::,
 ,:::::::::::::,   :x,  ,::  :,   ,:::::::::,
,:::::::::::::::,  ,,,  ,::, ,,  ,::::::::::,
,:::::::::::::::::,,,,,,:::::,,,,::::::::::::,    ,:,   ,:,            ,xx,                            ,:::::,   ,:,     ,:: :::,    ,x
,::::::::::::::::::::::::::::::::::::::::::::,    :x: ,:xx:        ,   :xx,                          :xxxxxxxxx, :xx,   ,xx:,xxxx,   :x
,::::::::::::::::::::::::::::::::::::::::::::,    :xxxxx:,  ,xx,  :x:  :xxx:x::,  ::xxxx:           :xx:,  ,:xxx  :xx, ,xx: ,xxxxx:, :x
,::::::::::::::::::::::::::::::::::::::::::::,    :xxxxx,   :xx,  :x:  :xxx,,:xx,:xx:,:xx, ,,,,,,,,,xxx,    ,xx:   :xx:xx:  ,xxx,:xx::x
,::::::,,::::::::,,::::::::,,:::::::,,,::::::,    :x:,xxx:  ,xx,  :xx  :xx:  ,xx,xxxxxx:, ,xxxxxxx:,xxx:,  ,xxx,    :xxx:   ,xxx, :xxxx
,::::,    ,::::,   ,:::::,   ,,::::,    ,::::,    :x:  ,:xx,,:xx::xxxx,,xxx::xx: :xx::::x: ,,,,,,   ,xxxxxxxxx,     ,xx:    ,xxx,  :xxx
,::::,    ,::::,    ,::::,    ,::::,    ,::::,    ,:,    ,:,  ,,::,,:,  ,::::,,   ,:::::,            ,,:::::,        ,,      :x:    ,::
,::::,    ,::::,    ,::::,    ,::::,    ,::::,
 ,,,,,    ,::::,    ,::::,    ,::::,    ,:::,             ,,,,,,,,,,,,,
          ,::::,    ,::::,    ,::::,    ,:::,        ,,,:::::::::::::::,
          ,::::,    ,::::,    ,::::,    ,::::,  ,,,,:::::::::,,,,,,,:::,
          ,::::,    ,::::,    ,::::,     ,::::::::::::,,,,,
           ,,,,     ,::::,     ,,,,       ,,,::::,,,,
                    ,::::,
                    ,,::,

Thanks for choosing Kube-OVN!
For more advanced features, please read https://github.com/kubeovn/kube-ovn#documents
If you have any question, please file an issue https://github.com/kubeovn/kube-ovn/issues/new/choose
2022-08-06T14:45:28 info succeeded in creating a new cluster, enjoy it!
2022-08-06T14:45:28 info
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

root@sealos-master0:~# kubectl get pod -n kube-system
NAME                                     READY   STATUS    RESTARTS   AGE
coredns-6d4b75cb6d-2h9l9                 1/1     Running   0          5m27s
coredns-6d4b75cb6d-4f78s                 1/1     Running   0          5m35s
etcd-sealos-master0                      1/1     Running   1          8m6s
kube-apiserver-sealos-master0            1/1     Running   1          8m
kube-controller-manager-sealos-master0   1/1     Running   1          8m5s
kube-ovn-cni-292rp                       1/1     Running   0          6m20s
kube-ovn-cni-mfn5z                       1/1     Running   0          6m20s
kube-ovn-cni-w2kkw                       1/1     Running   0          6m21s
kube-ovn-controller-6ff5f598d7-tpmhl     1/1     Running   0          6m21s
kube-ovn-monitor-5dbb6749-4zzht          1/1     Running   0          6m20s
kube-ovn-pinger-pqwhn                    1/1     Running   0          5m16s
kube-ovn-pinger-r4rgt                    1/1     Running   0          5m12s
kube-proxy-6kdqd                         1/1     Running   0          7m17s
kube-proxy-csbn7                         1/1     Running   0          7m17s
kube-proxy-fm2bj                         1/1     Running   0          7m51s
kube-scheduler-sealos-master0            1/1     Running   1          8m6s
kube-sealos-lvscare-sealos-node1         1/1     Running   1          6m50s
kube-sealos-lvscare-sealos-node2         1/1     Running   1          6m50s
ovn-central-d9b7646c8-x7qw2              1/1     Running   0          7m3s
ovs-ovn-2jx8q                            1/1     Running   0          7m3s
ovs-ovn-jwtk5                            1/1     Running   0          7m3s
ovs-ovn-nx59n                            1/1     Running   0          7m3s

```

## Uninstall

```shell
cd /var/lib/sealos/data/default/rootfs
sh ovn-uninstall.sh
```

## HomePage

https://kubeovn.github.io/docs/v1.10.x/
