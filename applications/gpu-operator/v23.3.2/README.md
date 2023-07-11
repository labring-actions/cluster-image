# NVIDIA GPU Operator

[NVIDIA GPU Operator](https://github.com/NVIDIA/gpu-operator) manages GPUs atop Kubernetes.

## Prerequisites
- **nodes without NVIDIA drivers installed**
- `kubernetes` (for stable GPU support, please use version v1.26 or higher)
- `sealos` >=4.0
- `helm` >=3

> This image by default installs drivers along with the gpu operator(This is done by setting `driver.enabled` in the Helm charts). If you do not need the drivers, please consider locally build the image or install the operator via [the official repository](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html#install-nvidia-gpu-operator).
 
## Installing the app
This image uses the default Helm values provided by the official repository. To install the app with `sealos run` command:

```bash
sealos run docker.io/labring/gpu-operator:v23.3.2
```

The above command will deploy `gpu-operator` with helm to the Kubernetes cluster in the namespace `gpu-operator` ，list app using:

```bash
helm -n gpu-operator ls
```

## Customization

Several options are available for the Helm chart. Please refer to [the official documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/getting-started.html#chart-customization-options). For example, switch MIG mode to `mixed` and configure the
dcgm exporter:

```bash
helm upgrade -n gpu-operator --reuse-values --set mig.strategy=mixed \
--set dcgmExporter.env[0].name=DCGM_EXPORTER_COLLECTORS \
--set dcgmExporter.env[0].value=/etc/dcgm-exporter/dcgm-metrics.csv \
 gpu-operator nvidia/gpu-operator
```

## Verification
Check the pods are running:

```
kubectl get pods -n gpu-operator
```

Check the node labels:
```
kubectl get node -o json | jq '.items[].metadata.labels'
```

Use `nvidia-smi` to check GPU status if you install driver with gpu-operator:

```
kubectl exec -it <driver-daemonset-pod> -n gpu-operator -- nvidia-smi
```