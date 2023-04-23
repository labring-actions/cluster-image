#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

mkdir -p scripts
wget -qO scripts/install.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/install.sh
wget -qO scripts/cleanup.sh https://raw.githubusercontent.com/kubeovn/kube-ovn/${VERSION}/dist/images/cleanup.sh
chmod +x scripts/*.sh

install_scripts="scripts/install.sh"
sed -i '/^POD_CIDR.*/c POD_CIDR=${POD_CIDR:-"100.64.0.0/10"}' ${install_scripts}
sed -i '/^POD_GATEWAY.*/c POD_GATEWAY=${POD_GATEWAY:-"100.64.0.1"}' ${install_scripts}
sed -i '/^SVC_CIDR.*/c SVC_CIDR=${SVC_CIDR:-"10.96.0.0/22"}' ${install_scripts}
sed -i '/^JOIN_CIDR.*/c JOIN_CIDR=${JOIN_CIDR:-"20.65.0.0/16"}' ${install_scripts}

sed -i '/^PINGER_EXTERNAL_ADDRESS.*/c PINGER_EXTERNAL_ADDRESS=${PINGER_EXTERNAL_ADDRESS:-"114.114.114.114"}' ${install_scripts}
sed -i '/^PINGER_EXTERNAL_DOMAIN.*/c PINGER_EXTERNAL_DOMAIN=${PINGER_EXTERNAL_DOMAIN:-"alauda.cn"}' ${install_scripts}
sed -i '/^SVC_YAML_IPFAMILYPOLICY.*/c SVC_YAML_IPFAMILYPOLICY=${SVC_YAML_IPFAMILYPOLICY:-}' ${install_scripts}
sed -i '/^EXCLUDE_IPS.*/c EXCLUDE_IPS=${EXCLUDE_IPS:-}' ${install_scripts}

sed -i '/^LABEL.*/c LABEL=${LABEL:-"node-role.kubernetes.io/control-plane"}' ${install_scripts}
sed -i '/^DEPRECATED_LABEL.*/c DEPRECATED_LABEL=${DEPRECATED_LABEL:-"node-role.kubernetes.io/master"}' ${install_scripts}
sed -i '/^NETWORK_TYPE.*/c NETWORK_TYPE=${NETWORK_TYPE:-"geneve"}' ${install_scripts}
sed -i '/^TUNNEL_TYPE.*/c TUNNEL_TYPE=${TUNNEL_TYPE:-"geneve"}' ${install_scripts}
sed -i '/^POD_NIC_TYPE.*/c POD_NIC_TYPE=${POD_NIC_TYPE:-"veth-pair"}' ${install_scripts}
sed -i '/^POD_DEFAULT_FIP_TYPE.*/c POD_DEFAULT_FIP_TYPE=${POD_DEFAULT_FIP_TYPE:-}' ${install_scripts}

# VLAN Config only take effect when NETWORK_TYPE is vlan
sed -i '/^PROVIDER_NAME.*/c PROVIDER_NAME=${PROVIDER_NAME:-"provider"}' ${install_scripts}
sed -i '/^VLAN_INTERFACE_NAME.*/c VLAN_INTERFACE_NAME=${VLAN_INTERFACE_NAME:-}' ${install_scripts}
sed -i '/^VLAN_NAME.*/c VLAN_NAME=${VLAN_NAME:-"ovn-vlan"}' ${install_scripts}
sed -i '/^VLAN_ID.*/c VLAN_ID=${VLAN_ID:-"100"}' ${install_scripts}

mkdir -p images/shim
image_tag=$(cat scripts/install.sh |grep "^VERSION=" | awk -F "[\"\"]" '{print $2}')
echo "docker.io/kubeovn/kube-ovn:${image_tag}" > images/shim/kubeovnImageList
