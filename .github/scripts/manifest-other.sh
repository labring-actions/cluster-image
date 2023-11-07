#!/bin/bash

set -eu

ARCH=${arch:-}
readonly IMAGE_NAME=${app?}
readonly IMAGE_TAG=${version?}
readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}
readonly IMAGE_NAME_FULL=${IMAGE_HUB_REGISTRY}/${IMAGE_HUB_REPO}/${IMAGE_NAME}:${IMAGE_TAG}

readonly buildDir=.build-image

rm -rf $buildDir
mkdir -p $buildDir

if [[ -d "applications/$IMAGE_NAME/latest" ]] && ! [[ -d "applications/$IMAGE_NAME/$IMAGE_TAG" ]]; then
    cp -af .github/scripts/apps/ /tmp/scripts_apps
    cp -af "applications/$IMAGE_NAME/latest" "applications/$IMAGE_NAME/$IMAGE_TAG"
fi

cp -rf "applications/$IMAGE_NAME/$IMAGE_TAG"/* $buildDir

if [[ -s "$buildDir/build_arch" ]]; then
    ARCH=$(cat "$buildDir/build_arch")
fi

# for host action ,Don't delete this code
sudo sealos rmi "$IMAGE_NAME_FULL" || true

sudo sealos manifest create "$IMAGE_NAME_FULL"
case $ARCH in
    amd64 | arm64)
        sudo sealos manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-$ARCH"
    ;;
    *)
        sudo sealos manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-amd64"
        sudo sealos manifest add "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL-arm64"
    ;;
esac
sudo sealos images

sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
    sudo sealos manifest push --all "$IMAGE_NAME_FULL" docker://"$IMAGE_NAME_FULL" && echo "$IMAGE_NAME_FULL push success"
sudo sealos manifest inspect $IMAGE_NAME_FULL

# for host action ,Don't delete this code
sudo sealos rmi "$IMAGE_NAME_FULL" || true
