#!/bin/bash

set -e

readonly commentVersion="$(echo "${commentbody?}" | awk '{print $2}')"
readonly defaultVersion="${sealos?}"

if [[ -n "$commentVersion" ]]; then
  sealosVersion=$commentVersion
else
  sealosVersion=$defaultVersion
fi

if ! wget -qO /dev/null "https://github.com/labring/sealos/releases/download/v$sealosVersion/sealos_${sealosVersion}_linux_amd64.tar.gz"; then
  echo "sealos version $sealosVersion does not exist"
  exit
fi

echo "sealos: $sealosVersion"
echo "::set-output name=sealoslatest::$sealosVersion"
