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
    if [[ -s init.sh ]]; then
        bash init.sh "$APP_ARCH" "$APP_NAME" "$APP_VERSION"
    fi
    IMAGE_NAME="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$APP_NAME:$APP_VERSION-$APP_ARCH"
    echo "init $IMAGE_NAME success"
}
