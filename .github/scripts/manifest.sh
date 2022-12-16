#!/bin/bash

set -eu

readonly CRI_TYPE=${criType?}

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}

readonly IMAGE_TAG=${version?}
readonly KUBE="${IMAGE_TAG%%-*}"
readonly sealoslatest="${IMAGE_TAG##*-}"
readonly SEALOS=${sealoslatest?}

readonly kube_major="${KUBE%.*}"
readonly sealos_major="${SEALOS%%-*}"
if [[ "${kube_major//./}" -ge 126 ]]; then
  if [[ "${sealos_major//./}" -le 413 ]]; then
    exit # skip
  fi
fi

case $CRI_TYPE in
containerd)
  IMAGE_KUBE=kubernetes
  ;;
docker)
  IMAGE_KUBE=kubernetes-docker
  ;;
esac

if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
  IMAGE_PUSH_NAME=(
    "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE%.*}"
  )
else
  if [[ "$SEALOS" == "$(
    until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
  )" ]]; then
    IMAGE_PUSH_NAME=(
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE"
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS"
    )
  else
    IMAGE_PUSH_NAME=(
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS"
    )
  fi
fi

for IMAGE_NAME in "${IMAGE_PUSH_NAME[@]}"; do
  sudo buildah manifest create "$IMAGE_NAME"
  sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-amd64"
  sudo buildah manifest add "$IMAGE_NAME" docker://"$IMAGE_NAME-arm64"
  sudo buildah login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
    sudo buildah manifest push --all "$IMAGE_NAME" docker://"$IMAGE_NAME" && echo "$IMAGE_NAME push success"
  sudo buildah manifest inspect $IMAGE_NAME
done
sudo buildah images

sudo buildah rmi "$IMAGE_NAME" || true
