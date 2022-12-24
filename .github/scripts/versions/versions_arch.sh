#!/bin/bash

set -e

readonly CRI_TYPE=${criType?}

readonly IMAGE_HUB_REGISTRY=${registry:-}
readonly IMAGE_HUB_REPO=${repo?}
readonly SEALOS=${sealoslatest?}

case $CRI_TYPE in
containerd)
  IMAGE_KUBE=kubernetes
  ;;
docker)
  IMAGE_KUBE=kubernetes-docker
  ;;
cri-o)
  IMAGE_KUBE=kubernetes-crio
  ;;
esac

# Recursively finds all directories with a go.mod file and creates
# a GitHub Actions JSON output option. This is used by the linter action.
echo "Resolving versions in $(pwd)"
rm -rf .versions
mkdir -p .versions
for file in $(pwd)/.github/versions/${part:-*}/CHANGELOG*; do
  K8S_MD=${file##*/}
  while IFS= read vKUBE; do
    if [[ "$allBuild" == true ]]; then
      echo "$vKUBE" >>".versions/$K8S_MD"
    else
      case $IMAGE_HUB_REGISTRY in
      docker.io)
        if until curl -sL "https://hub.docker.com/v2/repositories/$IMAGE_HUB_REPO/$IMAGE_KUBE/tags/$vKUBE-$SEALOS"; do sleep 3; done |
          grep digest >/dev/null; then
          echo "$IMAGE_HUB_REGISTRY/$IMAGE_HUB_REPO/$IMAGE_KUBE:$vKUBE-$SEALOS already existed"
        else
          echo "$vKUBE" >>".versions/$K8S_MD"
        fi
        ;;
      *)
        echo "$vKUBE" >>".versions/$K8S_MD"
        ;;
      esac
    fi
  done < <(
    until curl -sL "https://github.com/kubernetes/kubernetes/raw/master/CHANGELOG/$K8S_MD"; do sleep 3; done |
      grep -E '^- \[v[0-9\.]+\]' | awk '{print $2}' | awk -F\[ '{print $2}' | awk -F\] '{print $1}' >".versions/$K8S_MD.cached"
    head -n 1 ".versions/$K8S_MD.cached" >".versions/$K8S_MD.latest"
    if [[ docker == $CRI_TYPE ]]; then
      grep -vE "v1\.1(5-7)\..+" ".versions/$K8S_MD.cached"
    else
      cat ".versions/$K8S_MD.cached"
    fi
  )
  touch ".versions/$K8S_MD"
  if [[ -z "$(cat ".versions/$K8S_MD")" ]]; then
    mv ".versions/$K8S_MD.latest" ".versions/$K8S_MD"
  fi
  if ! [[ "$SEALOS" =~ ^[0-9\.]+[0-9]$ ]] || [[ -n "$sealosPatch" ]]; then
    cut -dv -f 2 ".versions/$K8S_MD" | head -n 1 |
      awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}' >>.versions/versions_arch.txt
  else
    cut -dv -f 2 ".versions/$K8S_MD" |
      awk '{printf "{\"'version'\":\"%s\",\"'arch'\":\"amd64\"},{\"'version'\":\"%s\",\"'arch'\":\"arm64\"},",$1,$1}' >>.versions/versions_arch.txt
  fi
done
SET_MATRIX=$(cat .versions/versions_arch.txt)
echo "{\"include\":[${SET_MATRIX%?}]}" | yq -P
echo "matrix={\"include\":[${SET_MATRIX%?}]}" >> $GITHUB_OUTPUT
