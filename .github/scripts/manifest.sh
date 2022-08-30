#!/bin/bash

set -eu

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
sudo buildah login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
  sudo buildah manifest push --all "$IMAGE_NAME" docker://"$IMAGE_NAME"

{
  KUBE="$(echo "${IMAGE_TAG%%-*}" | cut -dv -f 2)"
  if [[ $(wget -qO- "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/CHANGELOG-${KUBE%.*}.md" |
    grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' |
    cut -dv -f 2 | head -n 1) == "$KUBE" ]]; then
    for IMAGE_NAME in \
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE-dev:v${KUBE%.*}" \
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE"; do
      echo "===== $IMAGE_NAME ====="
      sudo buildah manifest create "$IMAGE_NAME"
      sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-amd64"
      sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-arm64"
      sudo buildah login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
        sudo buildah manifest push --all "$IMAGE_NAME" docker://"$IMAGE_NAME"
    done
  fi
}

sudo buildah rmi "$IMAGE_NAME" || true
