#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
export readonly ARCH=${1:-amd64}
export readonly NAME=${2:-$(basename "${PWD%/*}")}
export readonly VERSION=${3:-$(basename "$PWD")}

rm -rf opt && mkdir opt
wget -qO- https://github.com/helmfile/helmfile/releases/download/${VERSION}/helmfile_${VERSION#v}_linux_${ARCH}.tar.gz | tar -zx helmfile
mv helmfile opt/

readonly helm_version=${helmlatest:-$(
  until curl -sL "https://api.github.com/repos/helm/helm/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

readonly helm_diff_version=${helmDiffLatest:-$(
  until curl -sL "https://api.github.com/repos/databus23/helm-diff/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
)}

wget -qO- https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz | tar -zx linux-amd64/helm --strip=1
mv helm opt/

wget -qO- https://github.com/databus23/helm-diff/releases/download/v${helm_diff_version}/helm-diff-linux-amd64.tgz | tar -xz
mv diff opt/
