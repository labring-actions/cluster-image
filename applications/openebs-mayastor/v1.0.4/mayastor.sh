#!/usr/bin/env bash
set -e

sealos exec "
echo vm.nr_hugepages = 1024 | sudo tee -a /etc/sysctl.d/mayastor.conf 
sysctl -p
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
kubectl label node --overwrite --all openebs.io/engine=mayastor
kubectl apply -k ./manifests/mayastor/
