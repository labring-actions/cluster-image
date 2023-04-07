#!/bin/bash

set -eu

readonly ARCH=${arch:-}
readonly IMAGE_NAME=${app?}
readonly IMAGE_TAG=${version?}
readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}
readonly IMAGE_NAME_FULL=${IMAGE_HUB_REGISTRY}/${IMAGE_HUB_REPO}/${IMAGE_NAME}:${IMAGE_TAG}

# for host action ,Don't delete this code
sudo docker rmi "$IMAGE_NAME_FULL" || true

case $ARCH in
amd64 | arm64)
  sudo docker pull "$IMAGE_NAME_FULL-$ARCH"
  sudo docker manifest create "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-$ARCH"
  sudo docker manifest annotate "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-$ARCH" --arch $ARCH
  ;;
*)
  sudo docker pull "$IMAGE_NAME_FULL-amd64"
  sudo docker pull "$IMAGE_NAME_FULL-arm64"
  sudo docker manifest create "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-amd64"
  sudo docker manifest annotate "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-amd64" --arch amd64
  sudo docker manifest create "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-arm64"
  sudo docker manifest annotate "$IMAGE_NAME_FULL" "$IMAGE_NAME_FULL-arm64" --arch amd64
  ;;
esac
sudo docker images

sudo docker login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
  sudo docker manifest push "$IMAGE_NAME_FULL"  && echo "$IMAGE_NAME_FULL push success"
sudo docker manifest inspect $IMAGE_NAME_FULL

# for host action ,Don't delete this code
sudo docker rmi "$IMAGE_NAME_FULL" || true
