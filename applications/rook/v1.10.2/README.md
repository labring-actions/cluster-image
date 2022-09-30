## Build

Build with sealos

```
sealos build -f Kubefile -t labring/rook:v1.10.2 .
```

Get images list

```
wget https://raw.githubusercontent.com/rook/rook/v1.10.2/deploy/examples/images.txt
```

Download helm charts

```
helm repo add rook-release https://charts.rook.io/release
helm pull --version v1.10.2 rook-release/rook-ceph --untar -d charts
helm pull --version v1.10.2 rook-release/rook-ceph-cluster --untar -d charts
```

## Install

Prerequisites: see [official documents](https://rook.io/docs/rook/latest/Getting-Started/Prerequisites/prerequisites/).

This is for production configuration，you'll need three worker nodes with `8CPU/16G MEM` or more and each have one or more raw disk.

```
sealos run labring/rook:v1.10.2
```
