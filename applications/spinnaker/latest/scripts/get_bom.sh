#!/bin/bash

cd /workspace
halconfig_path=./halconfig
spinnaker_bom_path=${halconfig_path}/bom
spinnaker_bom_file=${spinnaker_version}.yml
mkdir -p ${spinnaker_bom_path}
gsutil -m cp -R gs://halconfig/versions.yml ./halconfig
gsutil -m cp -R gs://halconfig/bom/${spinnaker_bom_file} ${spinnaker_bom_path}
services=$(yq e '.services | keys | .[]' ${spinnaker_bom_path}/${spinnaker_bom_file})

for service in ${services}; do
  echo "download bom file of ${service}..."
  mkdir -p ${halconfig_path}/${service}
  spinnaker_service_path=${halconfig_path}/${service}
  version=$(service=${service} yq e '.services.[env(service)].version' ${spinnaker_bom_path}/${spinnaker_bom_file})
  gsutil -m cp -R gs://halconfig/${service}/${version} ${spinnaker_service_path}
done
