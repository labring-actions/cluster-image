#!/bin/bash
mkdir -p manifests
wget https://raw.githubusercontent.com/NVIDIA/dcgm-exporter/2.3.5-2.6.5/dcgm-exporter.yaml -O manifests/dcgm-exporter.yaml
wget https://raw.githubusercontent.com/NVIDIA/dcgm-exporter/2.3.5-2.6.5/service-monitor.yaml -O manifests/dcgm-monitor.yaml
