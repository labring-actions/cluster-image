#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

wget -qO ovn-install.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/install.sh
wget -qO ovn-cleanup.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/cleanup.sh
wget -qO ovn-uninstall.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/uninstall.sh

sed -i '/^POD_CIDR.*/c POD_CIDR=${POD_CIDR:-"100.64.0.0/10"}' ovn-install.sh
sed -i '/^POD_GATEWAY.*/c POD_GATEWAY=${POD_GATEWAY:-"100.64.0.1"}' ovn-install.sh
sed -i '/^SVC_CIDR.*/c SVC_CIDR=${SVC_CIDR:-"10.96.0.0/22"}' ovn-install.sh
sed -i '/^JOIN_CIDR.*/c JOIN_CIDR=${JOIN_CIDR:-"20.65.0.0/16"}' ovn-install.sh

mkdir -p images/shim
image_tag=$(cat ovn-install.sh |grep "^VERSION=" | awk -F "[\"\"]" '{print $2}')
echo "docker.io/kubeovn/kube-ovn:${image_tag}" > images/shim/kubeovnImageList
