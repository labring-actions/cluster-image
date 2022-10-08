## Build
Download 

```
wget https://raw.githubusercontent.com/mongodb/mongodb-kubernetes-operator/v0.7.6/config/samples/mongodb.com_v1_mongodbcommunity_cr.yaml
mv mongodb.com_v1_mongodbcommunity_cr.yaml manifests
```
Build
```
sealos build -t labring/mongodb-community-operator:0.7.6 .
```

## Usage
```
sealos run labring/mongodb-community-operator:0.7.6
```

