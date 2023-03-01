##How to use

1. connection cluster

```shell
telepresence connect
```

2. test cluster

```shell
  curl -ik https://kubernetes.default

```

if 502 error , maybe vpn proxy ,close vpn proxy try it.

3. run a app in local
go run xxxx

4. push your app in cluster

```shell
telepresence intercept example-service --port 8080:http --env-file ~/example-service-intercept.env
```

if error 