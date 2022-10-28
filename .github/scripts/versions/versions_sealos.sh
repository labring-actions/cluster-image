#!/bin/bash

set -e

readonly commentVersion="$(echo "${commentbody?}" | awk '{print $2}')"
readonly defaultVersion="$(until curl -sL "https://api.github.com/repos/labring/sealos/releases/latest"; do sleep 3; done | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2)"

if [[ -n "$commentVersion" ]]; then
  sealosVersion=$commentVersion
else
  sealosVersion=$defaultVersion
fi

if ! until curl -sL https://api.github.com/repos/labring/sealos/tags; do sleep 3; done |
  yq '.[].name' | grep "$sealosVersion" >/dev/null; then
  echo "sealos version $sealosVersion does not exist"
  exit
fi

echo "sealos: $sealosVersion"
echo "sealoslatest=$sealosVersion" >> $GITHUB_OUTPUT
