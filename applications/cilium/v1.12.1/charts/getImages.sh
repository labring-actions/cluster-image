#!/bin/bash

set -e

readonly CHART_DIR=${1?}

readonly binDIR="/tmp/$(whoami)/bin"
export PATH="$binDIR:$PATH"

yq >/dev/null 2>&1 || {
  wget -qO- "https://github.com/mikefarah/yq/releases/download/v$(
    curl --silent "https://api.github.com/repos/mikefarah/yq/releases/latest" | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
  )/yq_linux_amd64.tar.gz" |
    tar -zx
  mv -fv yq_* "$binDIR/yq"
}

helm >/dev/null 2>&1 || {
  wget -qO- "https://get.helm.sh/helm-v$(
    curl --silent "https://api.github.com/repos/helm/helm/releases/latest" | grep tarball_url | awk -F\" '{print $(NF-1)}' | awk -F/ '{print $NF}' | cut -dv -f2
  )-linux-amd64.tar.gz" |
    tar -zx linux-amd64/helm --strip-components=1
  mv -fv helm "$binDIR"
}

while IFS= read -r file; do
  head -n 1 "$file" | sed 's/(//g;s/)//g;s/ /\n/g' | grep .Values. | grep -v .tls. | sort | uniq |
    while IFS= read -r line; do
      yq -n "$line=true" >"$(date +%F).yaml$line"
    done
done < <(grep -E "^kind: (DaemonSet|Deployment|StatefulSet|Pod|Job|CronJob)$" -rl "$CHART_DIR")

# shellcheck disable=SC2016
yq ea '. as $item ireduce ({}; . * $item ) | .Values' "$(date +%F).yaml.Values."* >"$(date +%F).yaml.$CHART_DIR"
helm template "$CHART_DIR" -f "$(date +%F).yaml.$CHART_DIR" |
  grep image: | awk '{print $NF}' | sed 's/"//g' | sort | uniq

rm -f "$(date +%F).yaml."*
