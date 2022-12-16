#!/bin/bash

set -e

readonly commentVersion="$(echo "${commentbody?}" | awk '{print $2}')"
readonly defaultVersion="$(until curl -sL "https://api.github.com/repos/labring/sealos/tags" | yq '.[].name' | grep -E "^v.+$"; do sleep 1; done | grep -E "v[0-9.]+$" | head -n 1 | cut -dv -f2)"

if [[ -n "$commentVersion" ]]; then
  sealosVersion=$commentVersion
else
  sealosVersion=$defaultVersion
fi

if ! until curl -sL https://api.github.com/repos/labring/sealos/tags | yq .[].name | grep -E "^v.+$"; do sleep 3; done |
  grep "$sealosVersion" >/dev/null; then
  echo "sealos version $sealosVersion does not exist"
  exit 127
fi

echo "sealos: $sealosVersion"
echo "sealoslatest=$sealosVersion" >>$GITHUB_OUTPUT
