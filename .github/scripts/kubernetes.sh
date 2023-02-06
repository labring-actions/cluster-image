#!/bin/bash

set -eu

readonly ERR_CODE=127

readonly ARCH=${arch?}
readonly CRI_TYPE=${criType?}
readonly KUBE=${kubeVersion?}
readonly SEALOS=${sealoslatest?}

readonly kube_major="${KUBE%.*}"
readonly sealos_major="${SEALOS%%-*}"
if [[ "${kube_major//./}" -ge 126 ]]; then
  if ! [[ "${sealos_major//./}" -le 413 ]] || [[ -n "$sealosPatch" ]]; then
    echo "Verifying the availability of unstable"
  else
    echo "INFO::skip kube(>=1.26) building when sealos <= 4.1.3"
    exit
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
  if [[ -z "$sealosPatch" ]]; then
    FROM_SEALOS=$(sudo buildah from "$IMAGE_CACHE_NAME:sealos-v$SEALOS-$ARCH")
    MOUNT_SEALOS=$(sudo buildah mount "$FROM_SEALOS")
  else
    FROM_SEALOS=$(sudo buildah from "$sealosPatch-$ARCH")
    MOUNT_SEALOS=$(sudo buildah mount "$FROM_SEALOS")
    rmdir "$PATCH"
    sudo cp -a "$MOUNT_SEALOS" "$PATCH"
    sudo chown -R "$(whoami)" "$PATCH"
  fi
  FROM_KUBE=$(sudo buildah from "$IMAGE_CACHE_NAME:kubernetes-v$KUBE-$ARCH")
  MOUNT_KUBE=$(sudo buildah mount "$FROM_KUBE")
  FROM_CRIO=$(sudo buildah from "$IMAGE_CACHE_NAME:cri-v${KUBE%.*}-$ARCH")
  MOUNT_CRIO=$(sudo buildah mount "$FROM_CRIO")
  FROM_CRI=$(sudo buildah from "$IMAGE_CACHE_NAME:cri-$ARCH")
  MOUNT_CRI=$(sudo buildah mount "$FROM_CRI")
}

if [[ "${kube_major//./}" -ge 126 ]]; then
  case $CRI_TYPE in
  containerd)
    if ! [[ "$(sudo cat "$MOUNT_CRI"/cri/.versions | grep CONTAINERD | awk -F= '{print $NF}')" =~ v1\.([6-9]|[0-9][0-9])\.[0-9]+ ]]; then
      echo https://kubernetes.io/blog/2022/11/18/upcoming-changes-in-kubernetes-1-26/#cri-api-removal
      exit
    fi
    ;;
  docker)
    if ! [[ "$(sudo cat "$MOUNT_CRI"/cri/.versions | grep CRIDOCKER | awk -F= '{print $NF}')" =~ v0\.[3-9]\.[0-9]+ ]]; then
      echo https://github.com/Mirantis/cri-dockerd/issues/125
      exit
    fi
    ;;
  esac
fi

cp -a rootfs/* "$ROOT"
cp -a "$CRI_TYPE"/* "$ROOT"
cp -a registry/* "$ROOT"

cd "$ROOT" && {
  mkdir -p bin cri opt
  mkdir -p registry
  mkdir -p images/shim

  # cri
  sudo cp -a "$MOUNT_CRI"/cri/libseccomp.tar.gz cri/
  case $CRI_TYPE in
  containerd)
    sudo cp -a "$MOUNT_CRI"/cri/cri-containerd.tar.gz cri/
    ;;
  cri-o)
    if [[ -s "$MOUNT_CRIO"/cri/cri-o.tar.gz ]]; then
      sudo cp -a "$MOUNT_CRIO"/cri/cri-o.tar.gz cri/
    fi
    ;;
  docker)
    if [[ "${kube_major//./}" -ge 126 ]]; then
      sudo cp -a "$MOUNT_CRI"/cri/cri-dockerd.tgz cri/
    else
      sudo cp -a "$MOUNT_CRI"/cri/cri-dockerd.tgzv125 cri/cri-dockerd.tgz
    fi
    docker_major=$(until curl -sL "https://github.com/kubernetes/kubernetes/raw/release-${KUBE%.*}/build/dependencies.yaml" | yq '.dependencies[]|select(.name == "docker")|.version'; do sleep 3; done)
    case $docker_major in
    18.09 | 19.03 | 20.10)
      sudo cp -a "$MOUNT_CRI/cri/docker-$docker_major.tgz" cri/docker.tgz
      ;;
    *)
      sudo cp -a "$MOUNT_CRI/cri/docker.tgz" cri/
      ;;
    esac
    ;;
  esac

  sudo tar -xzf "$MOUNT_CRIO"/cri/crictl.tar.gz -C bin/
  sudo cp -a "$MOUNT_KUBE"/bin/kubeadm bin/
  sudo cp -a "$MOUNT_KUBE"/bin/kubectl bin/
  sudo cp -a "$MOUNT_KUBE"/bin/kubelet bin/
  sudo cp -a "$MOUNT_CRI"/cri/conntrack bin/
  sudo cp -a "$MOUNT_CRI"/cri/registry cri/
  sudo cp -a "$MOUNT_CRI"/cri/lsof opt/
  if [[ -z "$sealosPatch" ]]; then
    sudo cp -a "$MOUNT_SEALOS"/sealos/image-cri-shim cri/
    sudo cp -a "$MOUNT_SEALOS"/sealos/sealctl opt/
  else
    cp -a "$PATCH"/* .
  fi
  sudo chown -R "$(whoami)" bin cri opt
  if ! rmdir "$PATCH" 2>/dev/null; then
    ipvsImage="${sealosPatch%%/*}/labring/lvscare:$(find "registry" -type d | grep -E "tags/.+-$ARCH$" | awk -F/ '{print $NF}')"
    rm -f images/shim/lvscareImage
  else
    ipvsImage="ghcr.io/labring/lvscare:v$SEALOS"
  fi
  echo "$ipvsImage" >images/shim/LvscareImageList

  # replace
  sed -i "s#__lvscare__#$ipvsImage#g;s/v0.0.0/v$KUBE/g" "Kubefile"
  pauseImage=$(sudo grep /pause: "$MOUNT_KUBE/images/shim/DefaultImageList")
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

  IMAGE_BUILD="$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:build-$(date +%s)"
  sed -i -E "s#^FROM .+#FROM $IMAGE_CACHE_NAME:kubernetes-v$KUBE-$ARCH#" Kubefile
  tree -L 5
  sudo sealos build -t "$IMAGE_BUILD" --platform "linux/$ARCH" -f Kubefile .
  if [[ amd64 == "$ARCH" ]]; then
    if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
      dpkg-query --search "$(command -v containerd)" "$(command -v docker)"
      sudo apt-get remove -y moby-buildx moby-cli moby-compose moby-containerd moby-engine >/dev/null
      sudo systemctl unmask containerd docker || true
      sudo mkdir -p /sys/fs/cgroup/systemd
      sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd || true
      if ! sudo sealos run "$IMAGE_BUILD" --single; then
        export readonly SEALOS_RUN="failed"
        case $CRI_TYPE in
        containerd)
          sudo crictl ps -a || true
          ;;
        docker)
          sudo docker ps -a || true
          ;;
        esac
        systemctl status $CRI_TYPE || true
        journalctl -xeu $CRI_TYPE || true
        systemctl status kubelet || true
        journalctl -xeu kubelet || true
        exit $ERR_CODE
      else
        export readonly SEALOS_RUN="succeed"
        mkdir -p "$HOME/.kube"
        sudo cp -a /etc/kubernetes/admin.conf "$HOME/.kube/config"
        sudo chown "$(whoami)" "$HOME/.kube/config"
        # shellcheck disable=SC2046
        kubectl taint nodes $(kubectl get nodes --no-headers -l node-role.kubernetes.io/control-plane= | awk '{print $1}') node-role.kubernetes.io/master- || true
        until ! kubectl get pods --no-headers --all-namespaces | grep -vE Running; do
          sleep 5
        done
        kubectl get pods -owide --all-namespaces
        kubectl get node -owide
      fi
      dockerd info || true
      containerd --version || true
      sudo sealos reset --force
    else
      export readonly SEALOS_RUN="stable"
    fi
  else
    export readonly SEALOS_RUN="skipped"
  fi
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
  if [[ failed != "$SEALOS_RUN" ]]; then
    if sudo buildah inspect "$IMAGE_BUILD" | yq .OCIv1.architecture | grep "$ARCH" ||
      sudo buildah inspect "$IMAGE_BUILD" | yq .Docker.architecture | grep "$ARCH"; then
      echo -n >"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
      for IMAGE_NAME in "${IMAGE_PUSH_NAME[@]}"; do
        if [[ "$allBuild" != true ]]; then
          case $IMAGE_HUB_REGISTRY in
          docker.io)
            if until curl -sL "https://hub.docker.com/v2/repositories/$IMAGE_HUB_REPO/$IMAGE_KUBE/tags/${IMAGE_NAME##*:}"; do sleep 3; done |
              grep digest >/dev/null; then
              if ! grep "$KUBE" <<<"$${IMAGE_NAME##*:}" &>/dev/null;then
                # always push for kube 1.xx(DEV)
                echo "$IMAGE_NAME" >>"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
              else
                echo "$IMAGE_NAME already existed"
              fi
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
      if [[ -s "/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images" ]]; then
        sudo sealos login -u "$IMAGE_HUB_USERNAME" -p "$IMAGE_HUB_PASSWORD" "$IMAGE_HUB_REGISTRY"
        while read -r IMAGE_NAME; do
          sudo sealos tag "$IMAGE_BUILD" "$IMAGE_NAME"
          until sudo sealos push "$IMAGE_NAME"; do sleep 3; done
        done <"/tmp/$IMAGE_HUB_REGISTRY.v$KUBE-$ARCH.images"
      fi
    else
      sudo buildah inspect "$IMAGE_BUILD" | yq -CP
      echo "ERROR::TARGETARCH for sealos build"
      exit $ERR_CODE
    fi
  else
    sudo sealos version
  fi
}

sudo buildah umount "$FROM_SEALOS" "$FROM_KUBE" "$FROM_CRIO" "$FROM_CRI" || true
sudo sealos images
