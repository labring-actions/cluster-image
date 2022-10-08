#!/bin/sh
# entrypoint.sh
readonly ETCD_CLIENT_PORT=${ETCD_CLIENT_PORT:-2379}
readonly ETCD_PEER_PORT=${ETCD_PEER_PORT:-2380}

if [ -n "${KUBOARD_SSO_CLIENT_SECRET}" ]; then
  echo "使用环境变量中的 KUBOARD_SSO_CLIENT_SECRET: ${KUBOARD_SSO_CLIENT_SECRET}"
else
  client_secret=$(date +%s%N | md5sum |cut -c 1-24)
  export KUBOARD_SSO_CLIENT_SECRET=${client_secret}
  echo "生成 KUBOARD_SSO_CLIENT_SECRET: ${KUBOARD_SSO_CLIENT_SECRET}"
fi

if [ -n "${KUBOARD_ADMIN_DERAULT_PASSWORD}" ]; then
  echo "设置 KuboardAdmin 的默认密码（仅第一次启动时设置） ${KUBOARD_ADMIN_DERAULT_PASSWORD}"
  password=$(echo -n ${KUBOARD_ADMIN_DERAULT_PASSWORD} | md5sum | cut -d ' ' -f1)
  sed -i s/4df59565aa2497c16ac4f49a073ee318/$password/g /init-etcd-scripts/user.yaml
else
  echo "设置 KuboardAdmin 的默认密码（仅第一次启动时设置） Kuboard123"
fi

if [ -n "${KUBOARD_SERVER_NODE_PORT}" ]; then
  # 设置 KUBOARD_ENDPOINT
  export KUBOARD_ENDPOINT="${KUBOARD_ENDPOINT_PROTOCOL}${HOSTIP}:${KUBOARD_SERVER_NODE_PORT}"

  echo "KUBOARD_ENDPOINT ${KUBOARD_ENDPOINT}"

  # 设置 KUBERNETES_TOKEN
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
  export KUBERNETES_TOKEN=${KUBERNETES_TOKEN}

  NODES_RESP=$(curl -k "https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/nodes?labelSelector=node-role.kubernetes.io/master" \
    -H 'Cache-Control: no-cache' \
    -H 'Accept: application/json, text/plain, */*' \
    -H "Authorization: Bearer ${KUBERNETES_TOKEN}" \
    --compressed --insecure)

  NODES_RESP="[${NODES_RESP},$(curl -k "https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT}/api/v1/nodes?labelSelector=k8s.kuboard.cn/role%3Detcd,!node-role.kubernetes.io/master" \
    -H 'Cache-Control: no-cache' \
    -H 'Accept: application/json, text/plain, */*' \
    -H "Authorization: Bearer ${KUBERNETES_TOKEN}" \
    --compressed --insecure)]"
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

  KUBOARD_ETCD_ENDPOINTS=""
  i=0
  while [ $i -ne $count ]
  do
    i=$(($i+1))
    host=$(eval echo "$"host$i)
    ip=$(eval echo "$"ip$i)
    KUBOARD_ETCD_ENDPOINTS=${KUBOARD_ETCD_ENDPOINTS}${ip}:${ETCD_CLIENT_PORT}

    if [ $i -ne $count ]; then
      KUBOARD_ETCD_ENDPOINTS="${KUBOARD_ETCD_ENDPOINTS},"
    fi
  done

  echo ${KUBOARD_ETCD_ENDPOINTS}
  echo "kind: KuboardAdminConfig
etcd:
  endpoints: ${KUBOARD_ETCD_ENDPOINTS}
" > /root/.kuboard/conf.yaml
fi

KUBOARD_AGENT_KEY=`echo /proc/sys/kernel/random/uuid  | md5sum |cut -c 1-32`

if [ -f "/data/kuboard_agent_key" ];then
  read KUBOARD_AGENT_KEY < /data/kuboard_agent_key
else
  mkdir /data || true
  echo ${KUBOARD_AGENT_KEY} > /data/kuboard_agent_key
fi

sed -i s/KUBOARD_AGENT_KEY/${KUBOARD_AGENT_KEY}/g /etc/kuboard/kuboard-agent-server.ini

echo "start kuboard-agent-server"

kuboard-agent-server -c /etc/kuboard/kuboard-agent-server.ini &

if [ -n "${KUBOARD_SERVER_NODE_PORT}" ]; then
  echo "当前 Kuboard 在 K8S 中运行，etcd 独立部署"
elif [ "${KUBOARD_ETCD_ENDPOINTS}" != "127.0.0.1:${ETCD_CLIENT_PORT}" ]; then
  echo "使用独立部署的 ETCD  ${KUBOARD_ETCD_ENDPOINTS}"
else
  etcd \
  --name=kuboard-01 \
  --data-dir=/data/etcd-data \
  --listen-client-urls=http://0.0.0.0:${ETCD_CLIENT_PORT} \
  --advertise-client-urls=http://0.0.0.0:${ETCD_CLIENT_PORT} \
  --listen-peer-urls=http://0.0.0.0:${ETCD_PEER_PORT} \
  --initial-advertise-peer-urls=http://0.0.0.0:${ETCD_PEER_PORT} \
  --initial-cluster=kuboard-01=http://0.0.0.0:${ETCD_PEER_PORT} \
  --initial-cluster-token=tkn \
  --initial-cluster-state=new \
  --snapshot-count=10000 \
  --log-level=info \
  --logger=zap \
  --log-outputs=stderr &
fi

if [ "${KUBOARD_DISABLE_AUDIT}" != "true" ]; then
  if [ -n "${KUBOARD_QUEST_DB_URI}" ]; then
    echo "使用独立部署的 QuestDB   ${KUBOARD_QUEST_DB_URI}"
  else
    echo "启动内置的 QuestDB"
    mkdir /data/questdb-data || true
    /questdb/bin/questdb.sh start -d /data/questdb-data
  fi
else
  echo "KUBOARD_DISABLE_AUDIT is true, skip starting questdb."
fi

cat << EOF > /kuboard-root-user.yaml
kind: KuboardAuthGlobalRoleBinding
metadata:
  cluster: GLOBAL
  name: user.administrators.administrator
spec:
  subject:
    kind: KuboardAuthUser
    name: ${KUBOARD_ROOT_USER}
  role:
    name: administrator
EOF

if [ "${KUBOARD_LOGIN_TYPE}" != "default" ]; then
  rm -f /init-etcd-scripts/user.yaml
  mv /kuboard-root-user.yaml /init-etcd-scripts/kuboard-root-user.yaml
fi

if [ "${KUBOARD_LOGIN_TYPE}" != "default" ] && [ x"${KUBOARD_ROOT_USER}" = x ]; then
  echo "认证模块：未使用内建用户库，必须指定 KUBOARD_ROOT_USER 环境变量"
  exit 1
fi

while (true)
do
  sleep 15
  case ${KUBOARD_LOGIN_TYPE} in
  "gitlab")
    echo "认证模块：与 GitLab ${GITLAB_BASE_URL} 进行单点登录，不使用本地用户库"
    /kuboard-sso serve /kuboard-sso-config/gitlab-config.yaml &
    ;;
  "github")
    echo "认证模块：与 GitHub ${GITHUB_HOSTNAME} 进行单点登录，不使用本地用户库"
    /kuboard-sso serve /kuboard-sso-config/github-config.yaml &
    ;;
  "oidc")
    echo "认证模块：与 OpenID Connect ${UPSTREAM_OIDC_ISSUER} 进行单点登录，不使用本地用户库"
    /kuboard-sso serve /kuboard-sso-config/oidc-config.yaml &
    ;;
  "ldap")
    if [ "${LDAP_SKIP_SSL_VERIFY}" = "true" ]; then
      echo "认证模块：与 LDAP ${LDAP_HOST} 进行单点登录，不使用本地用户库"
      echo "LDAP_SKIP_SSL_VERIFY: ${LDAP_SKIP_SSL_VERIFY}"
      /kuboard-sso serve /kuboard-sso-config/ldap-config.yaml &
    else
      echo "认证模块：与 LDAP ${LDAP_HOST} 进行单点登录，不使用本地用户库"
      echo "LDAP_SKIP_SSL_VERIFY: ${LDAP_SKIP_SSL_VERIFY}"
      /kuboard-sso serve /kuboard-sso-config/ldap-config-secure.yaml &
    fi
    ;;
  "default")
    echo "认证模块：使用本地用户库"
    /kuboard-sso serve /kuboard-sso-config/default-config.yaml &
    ;;
  esac

  sleep 3s

  nginx

  /kuboard-server

  echo ""
  echo "启动 kuboard-server 失败，此问题通常是因为 Etcd 未能及时启动或者连接不上，系统将在 15 秒后重新尝试："
  echo "  1. 如果您使用 docker run 的方式运行 Kuboard，请耐心等候一会儿或者执行 docker restart kuboard；"
  echo "  2. 如果您将 Kuboard 安装在 Kubernetes 中，请检查 kuboard/kuboard-etcd 是否正常启动。"

done
