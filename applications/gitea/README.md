## Usage

Limitation: only support expose with nodePort, and you must provide one  kubernetes cluster nodeip.

```shell
sealos run labring/gitea:v1.17.3 --env NODE_IP=192.168.72.50
```

Access gitea from Brower, the default nodeport is `30033`, the default username/password is `gitea_admin/gitea_admin`

```shell
http://192.168.72.50:30033
```

## Custome nodeport

Limitation: only support below env:

```shell
sealos run labring/gitea:v1.17.3 --env NODE_IP=192.168.72.50 \
  --env HTTP_NODE_PORT=30033 --env SSH_NODE_PORT=30022
```

