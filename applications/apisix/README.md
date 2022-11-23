## build
```
sealos build -t labring/apisix:2.15.0 .
```
## Usage
```
sealos run labring/apisix:2.15.0
```

## env
Only support `SERVICE_TYPE` and `GATEWAY_TLS`
```
sealos run labring/apisix:2.15.0 --env --env SERVICE_TYPE="LoadBalancer" --env GATEWAY_TLS="true"
```
Custome your values
```
cd /var/lib/sealos/data/default/rootfs
helm upgrade apisix charts/apisix -n apisix --set gateway.tls.enabled=true --reuse-values
```
