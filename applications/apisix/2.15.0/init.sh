#!/bin/bash
arch=${1:-amd64}
apisix_charts_version=0.11.0
apisix_dashboard_charts_version=0.6.0

rm -rf charts
mkdir -p charts
helm repo add apisix https://charts.apiseven.com
helm pull apisix/apisix --version=${apisix_charts_version} -d charts --untar
helm pull apisix/apisix-dashboard --version=${apisix_dashboard_charts_version} -d charts --untar
