#!/bin/bash

cp opt/cilium /usr/bin/
cp opt/hubble /usr/bin/

if [ -z "$ExtraValues" ]
then
  cilium install --chart-directory charts/cilium --helm-set k8sServiceHost=apiserver.cluster.local,k8sServicePort=6443
else
  cilium install --chart-directory charts/cilium --helm-set k8sServiceHost=apiserver.cluster.local,k8sServicePort=6443,"$ExtraValues"
fi
