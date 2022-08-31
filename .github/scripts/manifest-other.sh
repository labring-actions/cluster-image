#!/bin/bash
readonly TYPE=${type?}
readonly IMAGE_NAME=${app?}
readonly IMAGE_TAG=${version?}
readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}
readonly IMAGE_NAME_FULL=${IMAGE_HUB_REGISTRY}/${IMAGE_HUB_REPO}/${IMAGE_NAME}:${IMAGE_TAG}

# for host action ,Don't delete this code
sudo buildah rmi "$IMAGE_NAME_FULL" || true
sudo buildah manifest create "$IMAGE_NAME_FULL"

case $TYPE in
amd64)
  sudo buildah manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-amd64"
  ;;
arm64)
  sudo buildah manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-arm64"
  ;;
*)
  sudo buildah manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-amd64"
  sudo buildah manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-arm64"
  ;;
esac

sudo buildah login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
    sudo buildah manifest push --all "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL" && echo "$IMAGE_NAME_FULL push success"

sudo buildah images
sudo buildah rmi "$IMAGE_NAME_FULL" || true
