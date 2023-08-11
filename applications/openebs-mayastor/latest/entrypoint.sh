#!/usr/bin/env bash
set -e

NAME=${NAME:-"mayastor"}
NAMESPACE=${NAMESPACE:-"mayastor"}
HELM_OPTS=${HELM_OPTS:-"--set=etcd.persistence.storageClass=manual \
--set=loki-stack.loki.persistence.storageClassName=manual"}

label_nodes_count=$(kubectl get nodes --show-labels | grep "openebs.io/engine=mayastor" | grep -v "NAME" | wc -l)
if [ "$label_nodes_count" -lt 3 ];then
  echo "The number of labeled nodes is less than 3, exit"
  echo "Please label with: kubectl label node <node_name> openebs.io/engine=mayastor"
  exit 1
fi

sealos exec "
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
echo vm.nr_hugepages = 1024 > /etc/sysctl.d/mayastor.conf
sysctl -p
systemctl restart kubelet
sudo modprobe -- nbd
sudo modprobe -- nvmet
sudo modprobe -- nvmet_rdma
sudo modprobe -- nvme_fabrics
sudo modprobe -- nvme_tcp
sudo modprobe -- nvme_rdma
sudo modprobe -- nvme_loop
cat <<EOF | sudo tee /etc/modules-load.d/mayastor.conf
nbd
nvmet
nvmet_rdma
nvme_fabrics
nvme_tcp
nvme_rdma
nvme_loop
EOF"

cp opt/kubectl-mayastor /usr/local/bin
helm upgrade -i ${NAME} ./charts/${NAME} -n ${NAMESPACE} --create-namespace ${HELM_OPTS}
