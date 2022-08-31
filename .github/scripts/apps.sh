#!/bin/bash

set -eu

readonly APP_NAME=${app?}
readonly APP_VERSION=${version?}
readonly APP_ARCH=${arch?}

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}

readonly buildDir=.build-image

rm -rf $buildDir
mkdir -p $buildDir

cp -rf "applications/$APP_NAME/$APP_VERSION"/* $buildDir

cd $buildDir && {
  [[ -s Dockerfile ]] && Kubefile="Dockerfile" || Kubefile="Kubefile"
  if [[ -s init.sh ]]; then
    bash init.sh "$APP_ARCH" "$APP_NAME" "$APP_VERSION"
  fi

  IMAGE_NAME="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$APP_NAME:$APP_VERSION-$APP_ARCH"

  IMAGE_BUILD="${IMAGE_NAME%%:*}:build-$(date +%s)"
  sudo sealos build -t "$IMAGE_BUILD" --platform "linux/$APP_ARCH" -f $Kubefile .

  sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME" && sudo sealos rmi -f "$IMAGE_BUILD"

  sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
    sudo sealos push "$IMAGE_NAME" && echo "$IMAGE_NAME push success"
}

sudo buildah images
