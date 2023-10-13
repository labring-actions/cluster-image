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

if [[ -d "applications/$APP_NAME/latest" ]] && ! [[ -d "applications/$APP_NAME/$APP_VERSION" ]]; then
  cp -af .github/scripts/apps/ /tmp/scripts_apps
  cp -af "applications/$APP_NAME/latest" "applications/$APP_NAME/$APP_VERSION"
fi

cp -rf "applications/$APP_NAME/$APP_VERSION"/* $buildDir

cd $buildDir && {
  [[ -s Dockerfile ]] && Kubefile="Dockerfile" || Kubefile="Kubefile"

  if [[ -s "build_arch" ]]; then
    FILE_CONTENT=$(cat "build_arch"| tr -d '[:space:]'| tr -d '\n'| tr -d '\t')
    if [[ "$FILE_CONTENT" != "$APP_ARCH" ]]; then
        echo "The content of build_arch does not match the ARCH variable. Exiting."
        exit 0
    fi
  fi
  if [[ -s init.sh ]]; then
    bash init.sh "$APP_ARCH" "$APP_NAME" "$APP_VERSION"
  fi

  IMAGE_NAME="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$APP_NAME:$APP_VERSION-$APP_ARCH"

  IMAGE_BUILD="${IMAGE_NAME%%:*}:build-$(date +%s)"
  sudo sealos build -t "$IMAGE_BUILD" --isolation=chroot --platform "linux/$APP_ARCH" -f $Kubefile .

  sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME" && sudo sealos rmi -f "$IMAGE_BUILD"

  sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
    sudo sealos push "$IMAGE_NAME" && echo "$IMAGE_NAME push success"
}

sudo buildah images
