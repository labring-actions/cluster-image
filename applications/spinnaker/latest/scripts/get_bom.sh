#!/bin/bash
set -e

export halconfig_path="./halconfig"
export spinnaker_bom_path="${halconfig_path}/bom"
export spinnaker_bom_file="${spinnaker_bom_path}/${spinnaker_version}.yml"

install_yq() {
    curl -sL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.40.2/yq_linux_amd64
    chmod a+x /usr/local/bin/yq
}

generate_spinnaker_boms() {
    mkdir -p ${spinnaker_bom_path}
    gsutil -m cp -c -R gs://halconfig/versions.yml ./halconfig
    gsutil -m cp -c -R gs://halconfig/bom/${spinnaker_version}.yml ${spinnaker_bom_path}
    services=$(yq e '.services | keys | .[]' ${spinnaker_bom_file} | grep -v monitoring-third-party)

    for service in ${services}; do
        echo "download bom file of ${service}..."
        mkdir -p ${halconfig_path}/${service}
        spinnaker_service_path=${halconfig_path}/${service}
        version=$(service=${service} yq e '.services.[env(service)].version' ${spinnaker_bom_file})
        gsutil -m cp -c -R gs://halconfig/${service}/${version} ${spinnaker_service_path}
    done
}

generate_spinnaker_images() {
    export spinnaker_version=${VERSION}
    export halyard_image="us-docker.pkg.dev/spinnaker-community/docker/halyard:stable"
    export spinnaker_dockerRegistry="us-docker.pkg.dev/spinnaker-community/docker/"
    export dockerhub_dockerRegistry="docker.io/library/"

    local images_dir="images/shim"
    local images_list="images/shim/images.txt"

    mkdir -p ${images_dir}
    yq -r '.services | to_entries | .[] | env(spinnaker_dockerRegistry) + .key + ":" + .value.version' ${spinnaker_bom_file} > ${images_list}
    #yq -r '.dependencies | to_entries | .[] | env(dockerhub_dockerRegistry) + .key + ":" + .value.version' ${spinnaker_bom_file} >> ${images_list}

    echo docker.io/library/redis:6.2 >> ${images_list}
    sed -i '/monitoring-third-party/d' ${images_list}
    echo "${halyard_image}" >> ${images_list}
    echo "docker.io/mikefarah/yq:4.40.2" >> ${images_list}

    yq e -i '.services.*.version |= "local:" + .' ${spinnaker_bom_file}
    tar -zcvf halconfig.tar.gz halconfig
    mkdir -p etc && mv halconfig.tar.gz etc/
    rm -rf halconfig
}

install_yq
generate_spinnaker_boms
generate_spinnaker_images
