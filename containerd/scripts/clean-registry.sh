#!/bin/bash
source common.sh
# prepare registry storage as directory
cd $(dirname $0)

VOLUME=${1:-/var/lib/registry}
CONFIG=${2:-/etc/registry}
container=sealos-registry

## rm container if exist.
if [ "$(nerdctl ps --format='{{json .Names}}' | grep \"$container\")" ]; then
    nerdctl rm -f $container
fi
rm -rf $VOLUME
rm -rf $CONFIG
rm -rf /etc/registry.yml
logger "clean registry success"
