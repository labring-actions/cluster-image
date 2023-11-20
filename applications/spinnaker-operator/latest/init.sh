#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

init_dir() {
    OPT_DIR="./opt"
    IMAGES_DIR="./images/shim"
    CHARTS_DIR="./charts"
    MANIFESTS_DIR="./manifest"

    rm -rf "${OPT_DIR}" "${CHARTS_DIR}" "${MANIFESTS_DIR}" "${IMAGES_DIR}"
    mkdir -p "${MANIFESTS_DIR}" "${IMAGES_DIR}"
}

download_spinnaker_operator_manifests() {
    local GITHUB_USER="armory"
    local GITHUB_REPO="spinnaker-operator"
    local GITHUB_FILE="manifests.tgz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/${VERSION}/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C "${MANIFESTS_DIR}"
}

download_spinnaker_kustomize_patches() {
    local GITHUB_USER="armory"
    local GITHUB_REPO="spinnaker-kustomize-patches"
    local GITHUB_FILE="master.tar.gz"
    local DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/refs/heads/${GITHUB_FILE}"

    wget -qO- "${DOWNLOAD_URL}" | tar -zx -C "${MANIFESTS_DIR}"
    rm -rf manifest/spinnaker-kustomize-patches-master/kustomization.yml
    cp -rf manifest/spinnaker-kustomize-patches-master/recipes/kustomization-all.yml manifest/spinnaker-kustomize-patches-master/kustomization.yml
}

download_spinnaker_images() {
    export halyard_image="us-docker.pkg.dev/spinnaker-community/docker/halyard:stable"
    export spinnaker_dockerRegistry="us-docker.pkg.dev/spinnaker-community/docker/"
    export dockerhub_dockerRegistry="docker.io/library/"
    local java_opts_proxy_env="-Dhttp.proxyHost=192.168.10.1 -Dhttp.proxyPort=7890 -Dhttps.proxyHost=192.168.10.1 -Dhttps.proxyPort=7890"
    local proxy_enabled="false"

    if [[ "${proxy_enabled}" == "false" ]]; then
        java_opts_proxy_env=""
    fi

    docker rm -f halyard &>/dev/null || true
    docker run -d -e JAVA_OPTS="${java_opts_proxy_env}" --name halyard ${halyard_image}

    for i in {1..3}; do
        status=$(docker exec -it halyard hal --ready &> /dev/null)
        if [ $? -eq 0 ]; then
            echo "halyard ready"
            break
        else
            echo "halyard not ready yet, retrying..."
            sleep 20s
        fi
    done

    if [ $? -ne 0 ]; then
        echo "Error: halyard failed to be ready after $i retries" >&2
        exit 1
    fi

    local latestSpinnaker=$(docker exec -it halyard hal version latest -q)
    local spinnaker_bom="${MANIFESTS_DIR}/spinnaker_bom.yaml"
    docker exec -it halyard hal version bom ${latestSpinnaker} -q -o yaml > "${spinnaker_bom}"
    yq -r '.services | to_entries | .[] | env(spinnaker_dockerRegistry) + .key + ":" + .value.version' "${spinnaker_bom}" > ${IMAGES_DIR}/spinnaker_images.txt

    local sinnaker_deployment="manifest/deploy/operator/cluster/deployment.yaml"
    local minio_deployment="manifest/spinnaker-kustomize-patches-master/core/persistence/in-cluster/minio.yml"
    cat ${sinnaker_deployment} | grep image: | awk -F"image: " '{print "docker.io/"$2}' >> ${IMAGES_DIR}/spinnaker_images.txt
    echo "us-docker.pkg.dev/spinnaker-community/redis/redis-cluster:v2" >> ${IMAGES_DIR}/spinnaker_images.txt
    cat ${minio_deployment} |grep image: | awk -F"image: " '{print "docker.io/"$2}' >> ${IMAGES_DIR}/spinnaker_images.txt
    sed -i '/monitoring-third-party/d' ${IMAGES_DIR}/spinnaker_images.txt
    sed -i "s|version:.*|version: ${latestSpinnaker}|g" manifests/spinnakerservice.yml.tmpl
}

main() {
    if [ $# -ne 3 ]; then
        echo "Usage: ./$0 <ARCH> <NAME> <VERSION>"
        exit 1
    else
        init_dir
        download_spinnaker_operator_manifests
        download_spinnaker_kustomize_patches
        download_spinnaker_images
    fi
}

main $@
