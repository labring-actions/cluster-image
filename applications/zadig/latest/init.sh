#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf charts && mkdir -p charts
helm repo add koderover-chart https://koderover.tencentcloudcr.com/chartrepo/chart
chart_version=`helm search repo --versions --regexp '\vkoderover-chart/zadig\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull koderover-chart/zadig --version=${chart_version} -d charts/ --untar

mkdir -p images/shim/

helm template xx charts/zadig | grep image: | awk '{print $2}' | grep -v image: |  tr -d '"' | grep -v "^$"  > images/shim/images1
helm template xx charts/zadig | grep image: | awk '{print $3}' | grep -v image: |  tr -d '"' | grep -v "^$" > images/shim/images2
helm template xx charts/zadig | grep IMAGE | awk '{print $2}' | grep -v IMAGE |  tr -d '"' | grep -v "^$" > images/shim/images3

cat <<'EOF' >"install.sh"
#!/bin/bash
IP=${1:-}
PORT=${2:-}
helm upgrade --install zadig koderover-chart/zadig --namespace zadig-system --create-namespace  --set endpoint.type=IP \
    --set endpoint.IP=${IP} \
    --set tags.minio=false \
    --set gloo.gatewayProxies.gatewayProxy.service.httpNodePort=${PORT} \
    --set global.extensions.extAuth.extauthzServerRef.namespace=zadig-system \
    --set gloo.gatewayProxies.gatewayProxy.service.type=NodePort \
    --set "dex.config.staticClients[0].redirectURIs[0]=http://${IP}:${PORT}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0"
EOF

cat <<'EOF' >"Kubefile"
FROM scratch
ENV IP=127.0.0.1
ENV PORT=30080
COPY charts charts
COPY registry registry
COPY install.sh install.sh
CMD ["bash install.sh $(IP) $(PORT)"]
EOF
