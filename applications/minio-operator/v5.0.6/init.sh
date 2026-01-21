#!/usr/bin/env bash
set -e

RetryPullFileInterval=3
RetrySleepSeconds=3
ARCHIVE="operator-5.0.6.tgz"

retryPullFile() {
  local file=$1
  local retry=0
  local retryMax=3
  set +e
      while [ $retry -lt $RetryPullFileInterval ]; do
          curl $file --create-dirs -o $ARCHIVE >/dev/null && break
          retry=$(($retry + 1))
          echo "retry pull file $file, retry times: $retry"
          sleep $RetrySleepSeconds
      done
      set -e
      if [ $retry -eq $retryMax ]; then
          echo "pull file $file failed"
          exit 1
      fi
}

retryPullFile https://raw.githubusercontent.com/minio/operator/master/helm-releases/operator-5.0.6.tgz