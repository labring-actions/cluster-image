#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

helm repo add redis-operator https://spotahome.github.io/redis-operator
chart_version=`helm search repo --versions --regexp '\vredis-operator/redis-operator\v' |grep ${VERSION#v} | awk '{print $2}' | sort -rn | head -n1`
helm pull redis-operator/redis-operator --version=${chart_version} -d charts/ --untar

mkdir -p images/shim
wget https://raw.githubusercontent.com/spotahome/redis-operator/${VERSION}/api/redisfailover/v1/defaults.go
redis_image_tag=$(cat defaults.go |grep defaultImage | awk -F "[\"\"]" '{print $2}' | awk -F: '{print $2}')
echo "docker.io/library/redis:${redis_image_tag}" > images/shim/redisImages
