#!/bin/sh
# docker-entrypoint.sh
readonly ETCD_CLIENT_PORT=${ETCD_CLIENT_PORT:-2379}
readonly ETCD_PEER_PORT=${ETCD_PEER_PORT:-2380}
KUBERNETES_TOKEN=""
if [ -f "/run/secrets/kubernetes.io/serviceaccount/token" ]
then
  read KUBERNETES_TOKEN < /run/secrets/kubernetes.io/serviceaccount/token
elif [ -f "/var/run/secrets/kubernetes.io/serviceaccount/token" ]
then
  read KUBERNETES_TOKEN < /var/run/secrets/kubernetes.io/serviceaccount/token
else
  echo -e "\033[31m未在如下路径找到 token\033[0m"
  echo "/run/secrets/kubernetes.io/serviceaccount/token"
  echo "/var/run/secrets/kubernetes.io/serviceaccount/token"
  exit;
fi

echo ${KUBERNETES_TOKEN}

NODES_RESP=$(curl -k "https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/nodes?labelSelector=node-role.kubernetes.io/master" \
  -H 'Cache-Control: no-cache' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: Bearer ${KUBERNETES_TOKEN}" \
  --compressed --insecure)

NODES_RESP="[
${NODES_RESP},
$(curl -k "https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/nodes?labelSelector=!node-role.kubernetes.io/master,node-role.kubernetes.io/control-plane" \
  -H 'Cache-Control: no-cache' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: Bearer ${KUBERNETES_TOKEN}" \
  --compressed --insecure),
$(curl -k "https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/nodes?labelSelector=k8s.kuboard.cn/role%3Detcd,!node-role.kubernetes.io/master,!node-role.kubernetes.io/control-plane" \
  -H 'Cache-Control: no-cache' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: Bearer ${KUBERNETES_TOKEN}" \
  --compressed --insecure)
]"
NODES_RESP=$(echo "$NODES_RESP"|sed -r 's+\\n++g')
echo "$NODES_RESP"
IPS=$(echo ${NODES_RESP} | jq -r '.[].items[].status.addresses[] | select(.type == "InternalIP") | .address')
HOSTS=$(echo ${NODES_RESP} | jq -r '.[].items[].status.addresses[] | select(.type == "Hostname") | .address')

echo ${HOSTS}
echo ${IPS}

IFS='
'
count=0
set -f
for line in $IPS; do
  count=`expr $count + 1`
  eval ip$count="${line}"
done

count=0
for line in $HOSTS; do
  count=`expr $count + 1`
  eval host$count="${line}"
done

set +f
unset IFS

PEERS=""
i=0
while [ $i -ne $count ]
do
  i=$(($i+1))
  host=$(eval echo "$"host$i)
  ip=$(eval echo "$"ip$i)
  PEERS=${PEERS}${host}=http://${ip}:${ETCD_PEER_PORT}

  if [ $i -ne $count ]; then
    PEERS="${PEERS},"
  fi
done

echo ${PEERS}

etcd --name ${HOSTNAME} \
  --listen-peer-urls http://${HOSTIP}:${ETCD_PEER_PORT} \
  --listen-client-urls http://${HOSTIP}:${ETCD_CLIENT_PORT} \
  --advertise-client-urls http://${HOSTIP}:${ETCD_CLIENT_PORT} \
  --initial-advertise-peer-urls http://${HOSTIP}:${ETCD_PEER_PORT} \
  --initial-cluster-token kuboard-etcd-cluster-1 \
  --initial-cluster ${PEERS} \
  --initial-cluster-state new \
  --snapshot-count=10000 \
  --log-level=info \
  --logger=zap \
  --data-dir /data
