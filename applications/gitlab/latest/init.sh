#!/usr/bin/env bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

repo_url="https://charts.gitlab.io/"
repo_name="gitlab/gitlab"
chart_name="gitlab"

app_version=${VERSION}

rm -rf charts && mkdir -p charts
helm repo add ${chart_name} ${repo_url}
chart_version=$(helm search repo --versions --regexp "\v"${repo_name}"\v" | grep ${app_version} | awk '{print $2}' | sort -rn | head -n1)
helm pull ${repo_name} --version=${chart_version} -d charts --untar

values_file_path="charts/gitlab/values.yaml"
yq e -i '.global.edition="ce"' ${values_file_path}
yq e -i '.gitlab-runner.install=false' ${values_file_path}
yq eval '. += {"certmanager-issuer": {"email": "email@example.com"}}' -i ${values_file_path}

match_line="\[runners.kubernetes\]"
insert_line="helper_image = \"registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-latest\""
sed -i "/$match_line/a \\
        $insert_line" "${values_file_path}"

mkdir -p images/shim
echo "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-latest" > images/shim/gitlab-images.txt

ubuntu_image=$(cat ${values_file_path} | grep "image = .*ubuntu:" | cut -d'"' -f2)
echo "docker.io/library/$ubuntu_image" >> images/shim/gitlab-images.txt
