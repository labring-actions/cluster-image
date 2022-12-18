#!/bin/bash

set -eu

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}
readonly SEALOS=${sealoslatest?}

readonly kube_major="${KUBE%.*}"
readonly sealos_major="${SEALOS%%-*}"
if [[ "${kube_major//./}" -ge 126 ]]; then
  if [[ "${sealos_major//./}" -le 413 ]]; then
    exit # skip
  fi
fi

readonly IMAGE_HUB_REGISTRY=${registry?}
readonly IMAGE_HUB_REPO=${repo?}
readonly IMAGE_HUB_USERNAME=${username?}
readonly IMAGE_HUB_PASSWORD=${password?}
readonly IMAGE_CACHE_NAME="ghcr.io/labring-actions/cache"

ROOT="/tmp/$(whoami)/build"
PATCH="/tmp/$(whoami)/patch"
mkdir -p "$ROOT" "$PATCH"

{
  BUILD_KUBE=$(sudo buildah from "$IMAGE_CACHE_NAME:kubernetes-v$KUBE-amd64")
  sudo cp -a "$(sudo buildah mount "$BUILD_KUBE")"/bin/kubeadm "/usr/bin/kubeadm"
  sudo buildah umount "$BUILD_KUBE"
  FROM_SEALOS=$(sudo buildah from "$IMAGE_CACHE_NAME:sealos-v$SEALOS-$ARCH")
  MOUNT_SEALOS=$(sudo buildah mount "$FROM_SEALOS")
  FROM_KUBE=$(sudo buildah from "$IMAGE_CACHE_NAME:kubernetes-v$KUBE-$ARCH")
  MOUNT_KUBE=$(sudo buildah mount "$FROM_KUBE")
  FROM_CRIO=$(sudo buildah from "$IMAGE_CACHE_NAME:cri-v${KUBE%.*}-$ARCH")
  MOUNT_CRIO=$(sudo buildah mount "$FROM_CRIO")
  FROM_CRI=$(sudo buildah from "$IMAGE_CACHE_NAME:cri-$ARCH")
  MOUNT_CRI=$(sudo buildah mount "$FROM_CRI")
}

if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
  BUILD_PATCH=$(sudo buildah from "$sealosPatch-$ARCH")
  rmdir "$PATCH"
  sudo cp -a "$(sudo buildah mount "$BUILD_PATCH")" "$PATCH"
  sudo chown -R "$USER:$USER" "$PATCH"
  sudo buildah umount "$BUILD_PATCH"
fi

cp -a rootfs/* "$ROOT"
cp -a "$CRI_TYPE"/* "$ROOT"
cp -a registry/* "$ROOT"

cd "$ROOT" && {
  mkdir -p bin
  mkdir -p opt
  mkdir -p registry
  mkdir -p images/shim
  mkdir -p cri/lib64

  # ImageList
  kubeadm config images list --kubernetes-version "$KUBE" 2>/dev/null >bin/kubeImageList

  # library
  TARGZ="$PWD/library.tgz"
  sudo cp -a "$MOUNT_CRI"/cri/library.tar.gz "$TARGZ"
  sudo chown -R "$(whoami)" "$TARGZ"
  {
    pushd bin
    tar -zxf "$TARGZ" library/bin --strip-components=2
    popd
    case $CRI_TYPE in
    containerd)
      cd cri/lib64 && {
        tar -zxf "$TARGZ" library/lib64 --strip-components=2
        mkdir -p lib
        mv libseccomp.* lib
        tar -czf containerd-lib.tar.gz lib
        rm -rf lib
        cd -
      }
      ;;
    esac
    rm -f "$TARGZ"
  }

  # cri
  case $CRI_TYPE in
  containerd)
    sudo cp -a "$MOUNT_CRI"/cri/cri-containerd.tar.gz cri/
    ;;
  cri-o)
    sudo cp -a "$MOUNT_CRIO"/cri/cri-o.tar.gz cri/
    ;;
  docker)
    case $KUBE in
    1.*.*)
      sudo cp -a "$MOUNT_CRI"/cri/cri-dockerd.tgz cri/
      sudo cp -a "$MOUNT_CRI"/cri/docker.tgz cri/
      ;;
    esac
    sudo cp -a "$MOUNT_CRIO"/cri/crictl.tar.gz cri/
    ;;
  esac

  sudo cp -a "$MOUNT_KUBE"/bin/kubeadm bin/
  sudo cp -a "$MOUNT_KUBE"/bin/kubectl bin/
  sudo cp -a "$MOUNT_KUBE"/bin/kubelet bin/
  sudo cp -a "$MOUNT_CRI"/cri/registry cri/
  sudo cp -a "$MOUNT_CRI"/cri/lsof opt/
  sudo cp -a "$MOUNT_SEALOS"/sealos/image-cri-shim cri/
  sudo cp -a "$MOUNT_SEALOS"/sealos/sealctl opt/
  sudo chown -R "$(whoami)" bin cri opt
  if ! rmdir "$PATCH" 2>/dev/null; then
    cp -a "$PATCH"/* .
    ipvsImage="${sealosPatch%%/*}/labring/lvscare:$(find "registry" -type d | grep -E "tags/.+-$ARCH$" | awk -F/ '{print $NF}')"
    rm -f images/shim/lvscareImage
  else
    ipvsImage="ghcr.io/labring/lvscare:v$SEALOS"
  fi
  echo "$ipvsImage" >images/shim/LvscareImageList

  # replace
  cri_shim_tmpl="etc/image-cri-shim.yaml.tmpl"
  if [[ "${sealos_major//./}" -le 413 ]]; then
    sed -i -E "s#.+v1.+v1alpha2.+#sync: 0#g" "$cri_shim_tmpl"
  fi
  cat "$cri_shim_tmpl"
  sed -i "s#__lvscare__#$ipvsImage#g;s/v0.0.0/v$KUBE/g" "Kubefile"
  pauseImage=$(grep /pause: bin/kubeImageList)
  pauseImageName=${pauseImage#*/}
  sed -i "s#__pause__#${pauseImageName}#g" Kubefile
  # build
  case $CRI_TYPE in
  containerd)
    IMAGE_KUBE=kubernetes
    ;;
  cri-o)
    IMAGE_KUBE=kubernetes-crio
    ;;
  docker)
    IMAGE_KUBE=kubernetes-docker
    ;;
  esac

  if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
    IMAGE_PUSH_NAME=(
      "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v${KUBE%.*}-$ARCH"
    )
  else
    if [[ "$SEALOS" == "$(
      until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
    )" ]]; then
      IMAGE_PUSH_NAME=(
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$ARCH"
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS-$ARCH"
      )
    else
      IMAGE_PUSH_NAME=(
        "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:v$KUBE-$SEALOS-$ARCH"
      )
    fi
  fi

  chmod a+x bin/* opt/*

  echo -n >"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
  for IMAGE_NAME in "${IMAGE_PUSH_NAME[@]}"; do
    if [[ "$allBuild" != true ]]; then
      case $IMAGE_HUB_REGISTRY in
      docker.io)
        if until curl -sL "https://hub.docker.com/v2/repositories/$IMAGE_HUB_REPO/$IMAGE_KUBE/tags/${IMAGE_NAME##*:}"; do sleep 3; done |
          grep digest >/dev/null; then
          echo "$IMAGE_NAME already existed"
        else
          echo "$IMAGE_NAME" >>"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
        fi
        ;;
      *)
        echo "$IMAGE_NAME" >>"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
        ;;
      esac
    else
      echo "$IMAGE_NAME" >>"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
    fi
  done

  IMAGE_BUILD="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:build-$(date +%s)"
  if [[ -s "/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images" ]]; then
    sed -i -E "s#^FROM .+#FROM $IMAGE_CACHE_NAME:kubernetes-v$KUBE-$ARCH#" Kubefile
    echo "COPY bin/kubeImageList images/shim/DefaultImageList" >>Kubefile
    tree -L 5
    sudo sealos build -t "$IMAGE_BUILD" --platform "linux/$ARCH" -f Kubefile .
    if [[ amd64 == "$ARCH" ]]; then
      if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
        sudo sealos run "$IMAGE_BUILD" --single --debug
        kubectl get nodes
        kubectl get pods --all-namespaces
      fi
    fi
    if sudo buildah inspect "$IMAGE_BUILD" | yq .OCIv1.architecture | grep "$ARCH" ||
      sudo buildah inspect "$IMAGE_BUILD" | yq .Docker.architecture | grep "$ARCH"; then
      {
        FROM_BUILD=$(sudo buildah from "$IMAGE_BUILD")
        MOUNT_BUILD=$(sudo buildah mount "$FROM_BUILD")
        while IFS= read -r i; do
          j=${i%/_manifests*}
          image=${j##*/}
          while IFS= read -r tag; do echo "$image:$tag"; done < <(sudo ls "$i")
        done < <(sudo find "${MOUNT_BUILD:-$PWD}" -name tags -type d | grep _manifests/tags)
        sudo buildah umount "$FROM_BUILD" || true
      }
      while read -r IMAGE_NAME; do
        sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME"
        sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY" &&
          sudo sealos push "$IMAGE_NAME" && echo "$IMAGE_NAME push success"
      done <"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
    else
      sudo buildah inspect "$IMAGE_BUILD" | yq -CP
      exit 127
    fi
    sudo sealos images
  fi
}

sudo buildah umount "$FROM_SEALOS" "$FROM_KUBE" "$FROM_CRIO" "$FROM_CRI" || true
