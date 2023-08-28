#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

function install(){
  cp -f opt/kubectl-dfpv /usr/local/bin/kubectl-dfpv
}

function uninstall(){
  rm -rf /usr/local/bin/kubectl-dfpv
}

function main(){
  if [ "$uninstall" = "true" ]; then
    uninstall
  else
    install
  fi
}

main $@
