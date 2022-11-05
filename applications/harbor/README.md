## Usage

1. Install harbor

limitation: only support expose with nodeport, so you must provide one node ip of your kubernetes cluster.

```shell
sealos run labring/harbor:v2.6.1 --env NODE_IP=192.168.72.50
```

2. Access harbor in Brower, the default nodeport is 30003.

```shell
https://<node-ip>:30003
```

3. Get harbor ca.crt

Get ca.crt and copy it to your docker client nodes.

```shell
kubectl -n harbor get secrets harbor-nginx -o jsonpath="{.data.ca\.crt}" | base64 -d >ca.crt
```

Create certs directory in docker client node, the `192.168.72.50` is your `NODE_IP`and `30003` is your nodePort.

```shell
mkdir -p /etc/docker/certs.d/192.168.72.50:30003/
```

Copy ca.crt to the directory

```shell
scp ca.crt /etc/docker/certs.d/192.168.72.15:30003/
```

Login harbor

```shell
docker login -u admin -p Harbor12345 https://192.168.72.50:30003
```

Push images

```shell
docker tag coredns/coredns:1.9.1 192.168.72.50:30003/library/coredns:1.9.1
docker push 192.168.72.50:30003/library/coredns:1.9.1
```

## Custome nodePort

Custome `INGRESS_CLASS_NAME` with deferente ingress controller, you can use `-f` option to force update your application.

```shell
sealos run -f labring/harbor:v2.6.1 --env NODE_IP=192.168.72.50 --env NODE_PORT=30010
```
