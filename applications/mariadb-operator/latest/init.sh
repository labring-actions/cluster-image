#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://mariadb-operator.github.io/mariadb-operator"
repo_name="mariadb-operator/mariadb-operator"
chart_name="mariadb-operator"

function init(){
  rm -rf charts && mkdir -p charts
  helm repo add ${chart_name} ${repo_url}
  chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1)
  helm pull ${repo_name} --version=${chart_version} -d charts --untar

  wget -qO- https://github.com/mariadb-operator/mariadb-operator/archive/refs/tags/v0.0.20.tar.gz | tar -zx
  rm -rf manifest && mkdir -p manifest
  mv mariadb-operator-0.0.20 manifest/mariadb-operator
  image_tag=$(yq .spec.image.tag manifest/mariadb-operator/examples/manifests/mariadb_v1alpha1_mariadb.yaml)
  mkdir -p images/shim/
  echo "docker.io/library/mariadb:${image_tag}" > images/shim/mariadb-operator-images.txt
}

init
