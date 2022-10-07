
prequires：openebs or other storage is needed by kubegems.

```
sealos run \
  --masters xxx --nodes xxx -p xxx \
  labring/kubernetes:v1.23.10 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/openebs:v1.9.0 \
  labring/kubegems:v1.21.4
```


## how to use

Start kubegems with one click:
1. install sealos
```
wget https://github.com/labring/sealos/releases/download/v4.1.3/sealos_4.1.3_linux_amd64.tar.gz \
   && tar zxvf sealos_4.1.3_linux_amd64.tar.gz sealos && chmod +x sealos && mv sealos /usr/bin
```
2. install kubegems with k8s
```
sealos run \
  --masters xxx --nodes xxx,xxx,xxx -p pwd \
  labring/kubernetes:v1.23.10 \
  labring/calico:v3.22.1 \
  labring/coredns:v0.0.1 \
  labring/openebs:v1.9.0 \
  labring/kubegems:v1.21.4
```
3. print success info

```
2022-10-07T01:00:05 info guest cmd is bash kubegems.sh
Release "kubegems-installer" does not exist. Installing it now.
NAME: kubegems-installer
LAST DEPLOYED: Fri Oct  7 01:00:05 2022
NAMESPACE: kubegems-installer
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kubegems-installer
CHART VERSION: 1.21.0
APP VERSION: 1.21.0

** Please be patient while the chart is being deployed **

%%Instructions to access the application depending on the serviceType and other considerations%%
Release "kubegems" does not exist. Installing it now.
NAME: kubegems
LAST DEPLOYED: Fri Oct  7 01:00:08 2022
NAMESPACE: kubegems
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kubegems
CHART VERSION: 1.21.0
APP VERSION: 1.21.0

** Please be patient while the chart is being deployed **

%%Instructions to access the application depending on the serviceType and other considerations%%
visit http://172.31.136.79:32529, user: admin password: demo!@#admin
2022-10-07T01:00:11 info succeeded in creating a new cluster, enjoy it!
2022-10-07T01:00:11 info
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

4. list all node image
```
root@sealos001:~# sealos exec  "crictl images  "
IMAGE                                            TAG                 IMAGE ID            SIZE
sealos.hub:5000/calico/cni                       v3.22.1             2a8ef6985a3e5       80.5MB
sealos.hub:5000/calico/kube-controllers          v3.22.1             c0c6672a66a59       54.9MB
sealos.hub:5000/calico/node                      v3.22.1             7a71aca7b60fc       69.6MB
sealos.hub:5000/calico/pod2daemon-flexvol        v3.22.1             17300d20daf93       8.46MB
sealos.hub:5000/coredns/coredns                  v1.8.6              a4ca41631cc7a       13.6MB
sealos.hub:5000/etcd                             3.5.1-0             25f8c7f3da61c       98.9MB
sealos.hub:5000/frrouting/frr                    stable_7.5          fa08f399392ea       56.4MB
sealos.hub:5000/kube-apiserver                   v1.23.10            9ca5fafbe8dc1       32.6MB
sealos.hub:5000/kube-controller-manager          v1.23.10            91a4a0d5de4e9       30.2MB
sealos.hub:5000/kube-proxy                       v1.23.10            71b9bf9750e1f       39.3MB
sealos.hub:5000/kube-scheduler                   v1.23.10            d5c0efb802d95       15.1MB
sealos.hub:5000/kubegems/fluent-bit              1.8.8-largebuf      9e159b3cd5da7       33.3MB
sealos.hub:5000/kubegems/install-cni             1.11.7              002626bcc337c       90.2MB
sealos.hub:5000/kubegems/k8s-dns-node-cache      1.21.1              5bae806f8f123       42.4MB
sealos.hub:5000/kubegems/kruise-manager          v1.2.0              cdbf498546dc4       85.8MB
sealos.hub:5000/kubegems/node-exporter           v1.3.1              1dbe0e9319764       10.6MB
sealos.hub:5000/kubegems/node-problem-detector   v0.8.10             c66065a6ee4e7       53.8MB
sealos.hub:5000/metallb/speaker                  v0.12.1             579ce8a43ea82       30.6MB
sealos.hub:5000/pause                            3.6                 6270bb605e12e       302kB
172.31.136.80: IMAGE                                                      TAG                   IMAGE ID            SIZE
172.31.136.80: sealos.hub:5000/calico/cni                                 v3.22.1               2a8ef6985a3e5       80.5MB
172.31.136.80: sealos.hub:5000/calico/node                                v3.22.1               7a71aca7b60fc       69.6MB
172.31.136.80: sealos.hub:5000/calico/pod2daemon-flexvol                  v3.22.1               17300d20daf93       8.46MB
172.31.136.80: sealos.hub:5000/calico/typha                               v3.22.1               f822f80398b9a       52.7MB
172.31.136.80: sealos.hub:5000/frrouting/frr                              stable_7.5            fa08f399392ea       56.4MB
172.31.136.80: sealos.hub:5000/kube-proxy                                 v1.23.10              71b9bf9750e1f       39.3MB
172.31.136.80: sealos.hub:5000/kubegems/alertmanager                      v0.24.0               e556bd45e16c2       27.8MB
172.31.136.80: sealos.hub:5000/kubegems/argo-rollouts                     v1.2.0                0f5eb3e58bc08       32.5MB
172.31.136.80: sealos.hub:5000/kubegems/cert-manager-controller           v1.8.0                2b8eb1ab5ff98       16.8MB
172.31.136.80: sealos.hub:5000/kubegems/cert-manager-webhook              v1.8.0                5efca4d28ca69       13.4MB
172.31.136.80: sealos.hub:5000/kubegems/configmap-reload                  v0.4.0                37e6075b1356c       4.44MB
172.31.136.80: sealos.hub:5000/kubegems/fluent-bit                        1.8.8-largebuf        9e159b3cd5da7       33.3MB
172.31.136.80: sealos.hub:5000/kubegems/fluentd                           v1.13.3-alpine-11.1   82ecaf2772187       88.2MB
172.31.136.80: sealos.hub:5000/kubegems/grafana                           8.5.3                 72af183985797       89.2MB
172.31.136.80: sealos.hub:5000/kubegems/install-cni                       1.11.7                002626bcc337c       90.2MB
172.31.136.80: sealos.hub:5000/kubegems/jaeger-collector                  1.30.0                8a3392ad2f86e       21.4MB
172.31.136.80: sealos.hub:5000/kubegems/jaeger-query                      1.30.0                a7beb08ff9fcb       26.7MB
172.31.136.80: sealos.hub:5000/kubegems/k8s-dns-node-cache                1.21.1                5bae806f8f123       42.4MB
172.31.136.80: sealos.hub:5000/kubegems/kruise-manager                    v1.2.0                cdbf498546dc4       85.8MB
172.31.136.80: sealos.hub:5000/kubegems/kube-rbac-proxy                   v0.8.0                ad393d6a4d1b1       20MB
172.31.136.80: sealos.hub:5000/kubegems/kube-state-metrics                v2.4.1                74a618d7bae7c       11.8MB
172.31.136.80: sealos.hub:5000/kubegems/kubegems                          v1.21.4               5f20bfac68756       39.9MB
172.31.136.80: sealos.hub:5000/kubegems/nginx-ingress-operator            0.5.2                 6b872298bbc92       11.4MB
172.31.136.80: sealos.hub:5000/kubegems/node-exporter                     v1.3.1                1dbe0e9319764       10.6MB
172.31.136.80: sealos.hub:5000/kubegems/node-problem-detector             v0.8.10               c66065a6ee4e7       53.8MB
172.31.136.80: sealos.hub:5000/kubegems/opentelemetry-collector-contrib   0.53.0                6a30e3555d63a       36.7MB
172.31.136.80: sealos.hub:5000/kubegems/prometheus-config-reloader        v0.56.2               c5f18f3ca2efd       4.83MB
172.31.136.80: sealos.hub:5000/kubegems/prometheus-operator               v0.56.2               6d35c91d43d84       14.4MB
172.31.136.80: sealos.hub:5000/labring/lvscare                            v4.1.3                59b6fbd01c482       54.9MB
172.31.136.80: sealos.hub:5000/metallb/controller                         v0.12.1               2373ab6c688a9       20.3MB
172.31.136.80: sealos.hub:5000/metallb/speaker                            v0.12.1               579ce8a43ea82       30.6MB
172.31.136.80: sealos.hub:5000/oamdev/kube-webhook-certgen                v2.3                  4720e64055618       22.1MB
172.31.136.80: sealos.hub:5000/oamdev/vela-core                           v1.3.5                2b949a12166de       21.4MB
172.31.136.80: sealos.hub:5000/openebs/linux-utils                        3.2.0                 9dbac87149842       25.9MB
172.31.136.80: sealos.hub:5000/openebs/node-disk-exporter                 1.9.0                 4a9b5a02319ed       47MB
172.31.136.80: sealos.hub:5000/pause                                      3.6                   6270bb605e12e       302kB
172.31.136.80: sealos.hub:5000/tigera/operator                            v1.25.3               648350e58702c       44.8MB
172.31.136.83: IMAGE                                                      TAG                 IMAGE ID            SIZE
172.31.136.83: sealos.hub:5000/calico/cni                                 v3.22.1             2a8ef6985a3e5       80.5MB
172.31.136.83: sealos.hub:5000/calico/node                                v3.22.1             7a71aca7b60fc       69.6MB
172.31.136.83: sealos.hub:5000/calico/pod2daemon-flexvol                  v3.22.1             17300d20daf93       8.46MB
172.31.136.83: sealos.hub:5000/calico/typha                               v3.22.1             f822f80398b9a       52.7MB
172.31.136.83: sealos.hub:5000/frrouting/frr                              stable_7.5          fa08f399392ea       56.4MB
172.31.136.83: sealos.hub:5000/kube-proxy                                 v1.23.10            71b9bf9750e1f       39.3MB
172.31.136.83: sealos.hub:5000/kubegems/elasticsearch                     7.17.1              515ab4fba8701       366MB
172.31.136.83: sealos.hub:5000/kubegems/fluent-bit                        1.8.8-largebuf      9e159b3cd5da7       33.3MB
172.31.136.83: sealos.hub:5000/kubegems/install-cni                       1.11.7              002626bcc337c       90.2MB
172.31.136.83: sealos.hub:5000/kubegems/k8s-dns-node-cache                1.21.1              5bae806f8f123       42.4MB
172.31.136.83: sealos.hub:5000/kubegems/kruise-manager                    v1.2.0              cdbf498546dc4       85.8MB
172.31.136.83: sealos.hub:5000/kubegems/kubegems                          v1.21.4             5f20bfac68756       39.9MB
172.31.136.83: sealos.hub:5000/kubegems/logging-operator                  3.17.6              7d466e9dca50e       22.4MB
172.31.136.83: sealos.hub:5000/kubegems/node-exporter                     v1.3.1              1dbe0e9319764       10.6MB
172.31.136.83: sealos.hub:5000/kubegems/node-problem-detector             v0.8.10             c66065a6ee4e7       53.8MB
172.31.136.83: sealos.hub:5000/kubegems/opentelemetry-collector-contrib   0.53.0              6a30e3555d63a       36.7MB
172.31.136.83: sealos.hub:5000/kubegems/pilot                             1.11.7              7a24235243a04       65.1MB
172.31.136.83: sealos.hub:5000/labring/lvscare                            v4.1.3              59b6fbd01c482       54.9MB
172.31.136.83: sealos.hub:5000/metallb/speaker                            v0.12.1             579ce8a43ea82       30.6MB
172.31.136.83: sealos.hub:5000/openebs/linux-utils                        3.2.0               9dbac87149842       25.9MB
172.31.136.83: sealos.hub:5000/openebs/node-disk-exporter                 1.9.0               4a9b5a02319ed       47MB
172.31.136.83: sealos.hub:5000/pause                                      3.6                 6270bb605e12e       302kB
172.31.136.82: IMAGE                                                TAG                     IMAGE ID            SIZE
172.31.136.82: sealos.hub:5000/calico/cni                           v3.22.1                 2a8ef6985a3e5       80.5MB
172.31.136.82: sealos.hub:5000/calico/node                          v3.22.1                 7a71aca7b60fc       69.6MB
172.31.136.82: sealos.hub:5000/calico/pod2daemon-flexvol            v3.22.1                 17300d20daf93       8.46MB
172.31.136.82: sealos.hub:5000/calico/typha                         v3.22.1                 f822f80398b9a       52.7MB
172.31.136.82: sealos.hub:5000/frrouting/frr                        stable_7.5              fa08f399392ea       56.4MB
172.31.136.82: sealos.hub:5000/kube-proxy                           v1.23.10                71b9bf9750e1f       39.3MB
172.31.136.82: sealos.hub:5000/kubegems/argo-rollouts               v1.2.0                  0f5eb3e58bc08       32.5MB
172.31.136.82: sealos.hub:5000/kubegems/cert-manager-cainjector     v1.8.0                  7c3e4d23dcd73       11.9MB
172.31.136.82: sealos.hub:5000/kubegems/cert-manager-ctl            v1.8.0                  0b904e2e30bcc       28.5MB
172.31.136.82: sealos.hub:5000/kubegems/fluent-bit                  1.8.8-largebuf          9e159b3cd5da7       33.3MB
172.31.136.82: sealos.hub:5000/kubegems/gems-kubectl                v1.21.4                 99771911d75f0       47.6MB
172.31.136.82: sealos.hub:5000/kubegems/install-cni                 1.11.7                  002626bcc337c       90.2MB
172.31.136.82: sealos.hub:5000/kubegems/jaeger-agent                1.30.0                  155239f570698       14.2MB
172.31.136.82: sealos.hub:5000/kubegems/jaeger-operator             1.30.0                  8d2decf6951bd       108MB
172.31.136.82: sealos.hub:5000/kubegems/jaeger-query                1.30.0                  a7beb08ff9fcb       26.7MB
172.31.136.82: sealos.hub:5000/kubegems/k8s-dns-node-cache          1.21.1                  5bae806f8f123       42.4MB
172.31.136.82: sealos.hub:5000/kubegems/kiali                       v1.38.1                 98681ffc5d952       79.6MB
172.31.136.82: sealos.hub:5000/kubegems/kruise-manager              v1.2.0                  cdbf498546dc4       85.8MB
172.31.136.82: sealos.hub:5000/kubegems/kubegems                    v1.21.4                 5f20bfac68756       39.9MB
172.31.136.82: sealos.hub:5000/kubegems/kubernetes-event-exporter   0.11.0-debian-10-r176   1df0ceee45a27       50MB
172.31.136.82: sealos.hub:5000/kubegems/loki                        2.5.0                   f042dc08d9f75       19.7MB
172.31.136.82: sealos.hub:5000/kubegems/metrics-server              v0.6.1                  e57a417f15d36       28.8MB
172.31.136.82: sealos.hub:5000/kubegems/nacos-peer-finder-plugin    1.1                     311427258b69f       78.3MB
172.31.136.82: sealos.hub:5000/kubegems/nacos-server                v2.1.1                  5ef6d98bd956d       519MB
172.31.136.82: sealos.hub:5000/kubegems/nginx-ingress               2.0.0                   15278223e2000       66.1MB
172.31.136.82: sealos.hub:5000/kubegems/node-exporter               v1.3.1                  1dbe0e9319764       10.6MB
172.31.136.82: sealos.hub:5000/kubegems/node-problem-detector       v0.8.10                 c66065a6ee4e7       53.8MB
172.31.136.82: sealos.hub:5000/kubegems/operator                    1.11.7                  a94d07df71c7c       64.3MB
172.31.136.82: sealos.hub:5000/kubegems/proxyv2                     1.11.7                  7dc9cbd4c60cf       83.8MB
172.31.136.82: sealos.hub:5000/kubegems/redis                       6.2.7-debian-10-r23     09c56ada60de0       39.3MB
172.31.136.82: sealos.hub:5000/labring/lvscare                      v4.1.3                  59b6fbd01c482       54.9MB
172.31.136.82: sealos.hub:5000/metallb/speaker                      v0.12.1                 579ce8a43ea82       30.6MB
172.31.136.82: sealos.hub:5000/oamdev/kube-webhook-certgen          v2.3                    4720e64055618       22.1MB
172.31.136.82: sealos.hub:5000/openebs/linux-utils                  3.2.0                   9dbac87149842       25.9MB
172.31.136.82: sealos.hub:5000/openebs/node-disk-exporter           1.9.0                   4a9b5a02319ed       47MB
172.31.136.82: sealos.hub:5000/pause                                3.6                     6270bb605e12e       302kB
172.31.136.81: IMAGE                                                 TAG                   IMAGE ID            SIZE
172.31.136.81: sealos.hub:5000/bitnami/argo-cd                       2.3.4-debian-10-r2    505e16a8ba554       141MB
172.31.136.81: sealos.hub:5000/bitnami/bitnami-shell                 10-debian-10-r432     ef654218b1098       32.2MB
172.31.136.81: sealos.hub:5000/bitnami/mysql                         8.0.29-debian-10-r2   76fed8e5cff66       125MB
172.31.136.81: sealos.hub:5000/bitnami/redis                         6.2.7-debian-10-r21   710eecf3a2fdc       39.3MB
172.31.136.81: sealos.hub:5000/bitnami/redis                         6.2.7-debian-10-r23   09c56ada60de0       39.3MB
172.31.136.81: sealos.hub:5000/calico/cni                            v3.22.1               2a8ef6985a3e5       80.5MB
172.31.136.81: sealos.hub:5000/calico/node                           v3.22.1               7a71aca7b60fc       69.6MB
172.31.136.81: sealos.hub:5000/calico/pod2daemon-flexvol             v3.22.1               17300d20daf93       8.46MB
172.31.136.81: sealos.hub:5000/frrouting/frr                         stable_7.5            fa08f399392ea       56.4MB
172.31.136.81: sealos.hub:5000/gitea/gitea                           1.16.8                39babc402491b       107MB
172.31.136.81: sealos.hub:5000/helm/chartmuseum                      v0.14.0               be6163bb71868       23.2MB
172.31.136.81: sealos.hub:5000/kube-proxy                            v1.23.10              71b9bf9750e1f       39.3MB
172.31.136.81: sealos.hub:5000/kubegems/appstore-charts              v1.21.4               0084906472168       22.6MB
172.31.136.81: sealos.hub:5000/kubegems/dashboard                    v1.21.4               3c019be1284c2       18.2MB
172.31.136.81: sealos.hub:5000/kubegems/fluent-bit                   1.8.8-largebuf        9e159b3cd5da7       33.3MB
172.31.136.81: sealos.hub:5000/kubegems/install-cni                  1.11.7                002626bcc337c       90.2MB
172.31.136.81: sealos.hub:5000/kubegems/k8s-dns-node-cache           1.21.1                5bae806f8f123       42.4MB
172.31.136.81: sealos.hub:5000/kubegems/kruise-manager               v1.2.0                cdbf498546dc4       85.8MB
172.31.136.81: sealos.hub:5000/kubegems/kubegems                     v1.21.4               5f20bfac68756       39.9MB
172.31.136.81: sealos.hub:5000/kubegems/node-exporter                v1.3.1                1dbe0e9319764       10.6MB
172.31.136.81: sealos.hub:5000/kubegems/node-problem-detector        v0.8.10               c66065a6ee4e7       53.8MB
172.31.136.81: sealos.hub:5000/kubegems/prometheus-config-reloader   v0.56.2               c5f18f3ca2efd       4.83MB
172.31.136.81: sealos.hub:5000/kubegems/prometheus                   v2.35.0               a5bac665ffa2c       82.9MB
172.31.136.81: sealos.hub:5000/labring/lvscare                       v4.1.3                59b6fbd01c482       54.9MB
172.31.136.81: sealos.hub:5000/metallb/speaker                       v0.12.1               579ce8a43ea82       30.6MB
172.31.136.81: sealos.hub:5000/openebs/linux-utils                   3.2.0                 9dbac87149842       25.9MB
172.31.136.81: sealos.hub:5000/openebs/node-disk-exporter            1.9.0                 4a9b5a02319ed       47MB
172.31.136.81: sealos.hub:5000/openebs/node-disk-operator            1.9.0                 f26bae023eda0       47.4MB
172.31.136.81: sealos.hub:5000/openebs/provisioner-localpv           3.2.0                 1b7ec8ed80346       28.8MB
172.31.136.81: sealos.hub:5000/pause                                 3.6                   6270bb605e12e       302kB

```

5. list all pod status
```
root@sealos001:~# kubectl get pod -A
NAMESPACE             NAME                                                         READY   STATUS      RESTARTS      AGE
argo-rollouts         argo-rollouts-847748b8b8-htqdl                               1/1     Running     0             22m
argo-rollouts         argo-rollouts-847748b8b8-mdj8z                               1/1     Running     0             22m
calico-system         calico-kube-controllers-67f85d7449-lbhh8                     1/1     Running     0             27m
calico-system         calico-node-cvw6c                                            1/1     Running     0             27m
calico-system         calico-node-dqw6s                                            1/1     Running     0             27m
calico-system         calico-node-glnsv                                            1/1     Running     0             27m
calico-system         calico-node-nsmpb                                            1/1     Running     0             27m
calico-system         calico-node-ppxx2                                            1/1     Running     0             27m
calico-system         calico-typha-65b76666f7-8j7hm                                1/1     Running     0             27m
calico-system         calico-typha-65b76666f7-gwtjp                                1/1     Running     0             27m
calico-system         calico-typha-65b76666f7-p249j                                1/1     Running     0             27m
cert-manager          cert-manager-cainjector-b78466dcb-g56dc                      1/1     Running     0             20m
cert-manager          cert-manager-d5596b859-f84gq                                 1/1     Running     0             20m
cert-manager          cert-manager-webhook-857944d4ff-fsdwl                        1/1     Running     0             20m
istio-system          istio-cni-node-4tzct                                         1/1     Running     0             21m
istio-system          istio-cni-node-9v98v                                         1/1     Running     0             21m
istio-system          istio-cni-node-dj5sz                                         1/1     Running     0             21m
istio-system          istio-cni-node-g5mdv                                         1/1     Running     0             21m
istio-system          istio-cni-node-k86t7                                         1/1     Running     0             21m
istio-system          istio-ingressgateway-575b6bccd6-wtkxs                        1/1     Running     0             21m
istio-system          istio-operator-944d86d85-sklhm                               1/1     Running     0             22m
istio-system          istiod-7594b9797f-t46jw                                      1/1     Running     0             21m
istio-system          kiali-7d5789c968-g258q                                       1/1     Running     0             22m
kruise-system         kruise-controller-manager-575b684648-27xdz                   1/1     Running     0             20m
kruise-system         kruise-controller-manager-575b684648-qpc82                   1/1     Running     0             20m
kruise-system         kruise-daemon-2pk88                                          1/1     Running     0             20m
kruise-system         kruise-daemon-6zk4v                                          1/1     Running     0             20m
kruise-system         kruise-daemon-h7548                                          1/1     Running     0             20m
kruise-system         kruise-daemon-qgwp7                                          1/1     Running     0             20m
kruise-system         kruise-daemon-rpl8b                                          1/1     Running     0             20m
kube-system           coredns-64897985d-pcztc                                      1/1     Running     0             28m
kube-system           coredns-64897985d-r5p4h                                      1/1     Running     0             28m
kube-system           etcd-sealos001                                               1/1     Running     1             28m
kube-system           kube-apiserver-sealos001                                     1/1     Running     1             28m
kube-system           kube-controller-manager-sealos001                            1/1     Running     1             28m
kube-system           kube-proxy-5l77n                                             1/1     Running     0             28m
kube-system           kube-proxy-7fgxl                                             1/1     Running     0             28m
kube-system           kube-proxy-jhrqf                                             1/1     Running     0             28m
kube-system           kube-proxy-nb4b9                                             1/1     Running     0             28m
kube-system           kube-proxy-w6cp8                                             1/1     Running     0             28m
kube-system           kube-scheduler-sealos001                                     1/1     Running     1             28m
kube-system           kube-sealos-lvscare-sealos002                                1/1     Running     1             27m
kube-system           kube-sealos-lvscare-sealos003                                1/1     Running     1             27m
kube-system           kube-sealos-lvscare-sealos004                                1/1     Running     1             27m
kube-system           kube-sealos-lvscare-sealos005                                1/1     Running     1             27m
kube-system           metrics-server-686c68fb49-469cv                              1/1     Running     0             20m
kube-system           node-local-dns-2rtsl                                         1/1     Running     0             20m
kube-system           node-local-dns-55stz                                         1/1     Running     0             20m
kube-system           node-local-dns-64znz                                         1/1     Running     0             20m
kube-system           node-local-dns-h52xj                                         1/1     Running     0             20m
kube-system           node-local-dns-l6d9p                                         1/1     Running     0             20m
kube-system           node-problem-detector-67q7l                                  1/1     Running     0             20m
kube-system           node-problem-detector-84ff2                                  1/1     Running     0             20m
kube-system           node-problem-detector-gnwhl                                  1/1     Running     0             20m
kube-system           node-problem-detector-jkf9r                                  1/1     Running     0             20m
kube-system           node-problem-detector-rnvmm                                  1/1     Running     0             20m
kubegems-eventer      kubernetes-event-exporter-65d79bb89b-kgksp                   1/1     Running     0             22m
kubegems-gateway      default-gateway-786c7ddfdb-4l9vv                             1/1     Running     0             21m
kubegems-gateway      nginx-ingress-operator-controller-manager-7cf46dcfc7-prlck   2/2     Running     0             22m
kubegems-installer    kubegems-installer-6dc9497cd5-4s8qn                          1/1     Running     0             28m
kubegems-local        kubegems-local-agent-5d8b9f755f-4sd9c                        1/1     Running     0             22m
kubegems-local        kubegems-local-controller-7b7795599c-q9zqj                   1/1     Running     0             23m
kubegems-local        kubegems-local-kubectl-7fc6d66b9c-b4s9t                      1/1     Running     0             23m
kubegems-logging      logging-operator-77586ff4f4-2t8f6                            1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentbit-2cxnm                     1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentbit-455z2                     1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentbit-5n68j                     1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentbit-6j9bk                     1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentbit-9qnrl                     1/1     Running     0             22m
kubegems-logging      logging-operator-logging-fluentd-0                           2/2     Running     0             22m
kubegems-logging      logging-operator-logging-fluentd-configcheck-d0b0c211        0/1     Completed   0             22m
kubegems-logging      logging-operator-logging-fluentd-configcheck-de68d16c        0/1     Completed   0             22m
kubegems-logging      loki-0                                                       1/1     Running     3 (22m ago)   22m
kubegems-logging      loki-redis-master-0                                          1/1     Running     0             22m
kubegems-monitoring   alertmanager-kube-prometheus-stack-alertmanager-0            2/2     Running     0             22m
kubegems-monitoring   grafana-6b4c6bbd97-99kzg                                     1/1     Running     0             20m
kubegems-monitoring   kube-prometheus-stack-kube-state-metrics-654844d6fc-sr2fb    1/1     Running     0             22m
kubegems-monitoring   kube-prometheus-stack-operator-7997854666-f8sp4              1/1     Running     0             22m
kubegems-monitoring   prometheus-kube-prometheus-stack-prometheus-0                2/2     Running     0             21m
kubegems-monitoring   prometheus-node-exporter-56h7k                               1/1     Running     0             20m
kubegems-monitoring   prometheus-node-exporter-8wh7c                               1/1     Running     0             20m
kubegems-monitoring   prometheus-node-exporter-kxwjv                               1/1     Running     0             20m
kubegems-monitoring   prometheus-node-exporter-qr2wm                               1/1     Running     0             20m
kubegems-monitoring   prometheus-node-exporter-xckzl                               1/1     Running     0             20m
kubegems              kubegems-api-76585679c9-dps5q                                1/1     Running     4 (26m ago)   27m
kubegems              kubegems-argo-cd-app-controller-5b849bfb49-kdkjf             1/1     Running     0             27m
kubegems              kubegems-argo-cd-repo-server-7dddd8f57d-c9dsm                1/1     Running     0             27m
kubegems              kubegems-argo-cd-server-76745cc657-6nscm                     1/1     Running     0             27m
kubegems              kubegems-chartmuseum-6c546b4d-smr8s                          1/1     Running     0             27m
kubegems              kubegems-charts-init-v1.21.4-sw28v                           0/1     Completed   0             27m
kubegems              kubegems-dashboard-6c6d8f9bdb-kfcrp                          1/1     Running     0             27m
kubegems              kubegems-gitea-0                                             1/1     Running     0             27m
kubegems              kubegems-init-v1.21.4-w5j8j                                  0/1     Completed   4             27m
kubegems              kubegems-msgbus-d64657ff6-4hcz4                              1/1     Running     4 (26m ago)   27m
kubegems              kubegems-mysql-0                                             1/1     Running     0             27m
kubegems              kubegems-redis-master-0                                      1/1     Running     0             3m57s
kubegems              kubegems-worker-65cd7d66f4-t7vqv                             1/1     Running     4 (26m ago)   27m
metallb               metallb-controller-777cbcf64f-78q9k                          1/1     Running     0             20m
metallb               metallb-speaker-8ktqg                                        4/4     Running     0             20m
metallb               metallb-speaker-cgbjs                                        4/4     Running     0             20m
metallb               metallb-speaker-m9k4w                                        4/4     Running     0             20m
metallb               metallb-speaker-tczzw                                        4/4     Running     0             20m
metallb               metallb-speaker-tv6wg                                        4/4     Running     0             20m
nacos                 nacos-0                                                      1/1     Running     0             3m38s
observability         elasticsearch-master-0                                       1/1     Running     0             22m
observability         jaeger-operator-dd766fc5f-snndj                              1/1     Running     0             22m
observability         jaeger-operator-jaeger-collector-6599fd7f49-8l6fv            1/1     Running     3 (21m ago)   22m
observability         jaeger-operator-jaeger-query-6dbc7677b-vdfkj                 2/2     Running     3 (21m ago)   21m
observability         opentelemetry-collector-6c64fd6656-bxwsd                     1/1     Running     0             22m
observability         opentelemetry-collector-6c64fd6656-c9dnl                     1/1     Running     0             22m
openebs               openebs-localpv-provisioner-8f86bbf56-rdczv                  1/1     Running     0             28m
openebs               openebs-ndm-cluster-exporter-866d5ff9c5-bt8cz                1/1     Running     0             28m
openebs               openebs-ndm-node-exporter-qcc4x                              1/1     Running     0             27m
openebs               openebs-ndm-node-exporter-qstb2                              1/1     Running     0             27m
openebs               openebs-ndm-node-exporter-wd6cb                              1/1     Running     0             27m
openebs               openebs-ndm-node-exporter-xl2nr                              1/1     Running     0             27m
openebs               openebs-ndm-operator-6ffdf4dd7d-nvh6k                        1/1     Running     0             28m
tigera-operator       tigera-operator-b876f5799-b7nhd                              1/1     Running     0             28m
vela-system           kubevela-vela-core-66fc6d4d6b-lkcdc                          1/1     Running     0             22m
```

6. all plugins
```
root@sealos001:~# kubectl get plugins -A
NAMESPACE             NAME                        KIND        STATUS      NAMESPACE             VERSION   APPVERSION   UPGRADETIMESTAMP   AGE
argo-rollouts         argo-rollouts               helm        Installed   argo-rollouts         2.14.0    v1.2.0       23m                23m
cert-manager          cert-manager                helm        Installed   cert-manager          v1.8.0    v1.8.0       21m                21m
istio-system          istio-operator              helm        Installed   istio-system          1.0.0     1.0.0        23m                23m
istio-system          kiali-server                helm        Installed   istio-system          1.38.1    v1.38.1      23m                23m
kruise-system         openkruise                  helm        Installed   kruise-system         1.2.0     1.2.0        21m                21m
kube-system           external-snapshotter        kustomize   Installed   kube-system           5.0.1                  24m                24m
kube-system           metrics-server              helm        Installed   kube-system           3.8.2     0.6.1        22m                22m
kube-system           node-local-dns              helm        Installed   kube-system           0.1.1     1.21.1       21m                21m
kube-system           node-problem-detector       helm        Installed   kube-system           2.2.2     v0.8.10      21m                21m
kubegems-eventer      kubernetes-event-exporter   helm        Installed   kubegems-eventer      1.4.12    0.11.0       24m                24m
kubegems-local        argo-rollouts               template    Installed   argo-rollouts         1.0.0     2.14.0       23m                24m
kubegems-local        cert-manager                template    Installed   cert-manager          1.0.0     1.8.0        21m                24m
kubegems-local        eventer                     template    Installed   kubegems-eventer      1.0.0     1.4.12       23m                24m
kubegems-local        gateway                     template    Installed   kubegems-gateway      1.0.0     0.3.2        23m                24m
kubegems-local        grafana                     template    Installed   kubegems-monitoring   1.0.0     6.29.5       22m                24m
kubegems-local        istio                       template    Installed   istio-system          1.0.0     1.11.7       23m                24m
kubegems-local        kubegems-local              helm        Installed   kubegems-local        0.0.0     1.21.0       23m                24m
kubegems-local        kubevela                    template    Installed   vela-system           1.0.0     1.3.5        23m                24m
kubegems-local        local-path                  template    Disabled                                                                    24m
kubegems-local        logging                     template    Installed   kubegems-logging      1.0.0     3.17.6       23m                24m
kubegems-local        metallb                     template    Installed   metallb               1.0.0     0.12.1       21m                24m
kubegems-local        metrics-server              template    Installed   kube-system           1.0.0     3.8.2        22m                24m
kubegems-local        monitoring                  template    Installed   kubegems-monitoring   1.0.0     35.2.0       23m                24m
kubegems-local        nacos                       template    Installed   nacos                 1.0.0     2.1.1        20m                24m
kubegems-local        node-local-dns              template    Installed   kube-system           1.0.0     0.1.1        21m                24m
kubegems-local        node-problem-detector       template    Installed   kube-system           1.0.0     2.2.2        21m                24m
kubegems-local        nvidia-device-plugin        template    Disabled                                                                    24m
kubegems-local        openkruise                  template    Installed   kruise-system         1.0.0     1.2.0        21m                24m
kubegems-local        opentelemetry               template    Installed   observability         1.0.0     0.20.0       23m                24m
kubegems-local        prometheus-node-exporter    template    Installed   kubegems-monitoring   1.0.0     3.3.0        22m                24m
kubegems-local        tke-gpu-manager             template    Disabled                                                                    24m
kubegems-local        tracing                     template    Installed   observability         1.0.0     1.30.0       23m                24m
kubegems-local        volume-snapshoter           template    Installed   kube-system           1.0.0     5.0.1        24m                24m
kubegems-logging      logging-operator            helm        Installed   kubegems-logging      3.17.6    3.17.6       24m                24m
kubegems-logging      logging-operator-logging    helm        Installed   kubegems-logging      3.17.6    3.17.6       23m                24m
kubegems-logging      loki                        helm        Installed   kubegems-logging      2.11.1    v2.5.0       23m                24m
kubegems-logging      loki-redis                  helm        Installed   kubegems-logging      16.9.11   6.2.7        24m                24m
kubegems-monitoring   grafana                     helm        Installed   kubegems-monitoring   6.29.5    8.5.3        22m                22m
kubegems-monitoring   kube-prometheus-stack       helm        Installed   kubegems-monitoring   35.2.0    0.56.2       23m                24m
kubegems-monitoring   prometheus-node-exporter    helm        Installed   kubegems-monitoring   3.3.0     1.3.1        22m                22m
metallb               metallb                     helm        Installed   metallb               0.12.1    v0.12.1      21m                21m
nacos                 nacos                       helm        Installed   nacos                 0.1.5     1.0          20m                20m
observability         elasticsearch               helm        Installed   observability         7.17.1    7.17.1       23m                23m
observability         jaeger-operator             helm        Installed   observability         2.30.0    1.32.0       23m                23m
observability         opentelemetry-collector     helm        Installed   observability         0.20.0    0.53.0       23m                23m
vela-system           kubevela                    helm        Installed   vela-system           1.3.5     1.3.5        23m                23m
``

