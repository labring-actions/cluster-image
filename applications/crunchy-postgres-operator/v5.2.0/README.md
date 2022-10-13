## Build
Download manifests
```
git clone --depth 1 https://github.com/CrunchyData/postgres-operator-examples.git
mv postgres-operator-examples manifests
mv postgres-operator-examples/helm/install charts/crunchy-postgres-operator
```
Build
```
sealos build -t labring/crunchy-postgres-operator:v5.2.0 .
```

## Usage
```
sealos run labring/crunchy-postgres-operator:v5.2.0
```
