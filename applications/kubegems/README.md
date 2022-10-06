## how to use

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

