#!/bin/bash

IMAGE_DOMAIN=${IMAGE_DOMAIN:-registry.cn-hangzhou.aliyuncs.com}
IMAGE_NAMESPACE=${IMAGE_NAMESPACE:-goodrain}
VERSION=${VERSION:-'v5.15.0-release'}

image_list="${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/kubernetes-dashboard:v2.6.1
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/registry:2.6.2
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/metrics-server:v0.4.1
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/etcd:v3.3.18
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/metrics-scraper:v1.0.4
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rainbond:${VERSION}-allinone
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-mesh-data-panel:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-webcli:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-eventlog:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-init-probe:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-chaos:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-mq:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/resource-proxy:v5.10.0-release
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rainbond-operator:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-worker:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-node:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-monitor:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-gateway:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-api:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/rbd-db:8.0.19
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/builder:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/runner:${VERSION}
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/mysqld-exporter:latest
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/nfs-provisioner:latest
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/helm-env-checker:latest
${IMAGE_DOMAIN}/${IMAGE_NAMESPACE}/kaniko-executor:latest"

#for image in ${image_list}; do
#	    docker pull "${image}"
#    done
#
#docker save -o rainbond-"${VERSION}".tar ${image_list}

echo -e $image_list | tr ' ' '\n' > images/shim/rainbond-images.txt
sed -i "s#runner:v5.15.0-release#runner:latest#g" images/shim/rainbond-images.txt
sed -i "s#builder:v5.15.0-release#builder:latest#g" images/shim/rainbond-images.txt
