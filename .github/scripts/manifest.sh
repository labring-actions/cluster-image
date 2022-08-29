#!/bin/bash

set -e

readonly CRI_TYPE=${criType}

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}

readonly IMAGE_TAG=${version?}

case $CRI_TYPE in
containerd)
  IMAGE_KUBE=kubernetes
  ;;
docker)
  IMAGE_KUBE=kubernetes-docker
  ;;
esac

IMAGE_NAME="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:$IMAGE_TAG"

sudo buildah rmi "$IMAGE_NAME" || true

sudo buildah manifest create "$IMAGE_NAME"
sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-amd64"
sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-arm64"

sudo buildah login --username "$IMAGE_HUB_USERNAME" --password "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY"
sudo buildah manifest push --all "$IMAGE_NAME" docker://"$IMAGE_NAME"
sudo sealos login "$IMAGE_HUB_REGISTRY" -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD"

sudo buildah rmi "$IMAGE_NAME" || true
