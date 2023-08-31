#!/bin/bash
domain=$(cat /var/lib/sealos/data/default/rootfs/etc/registry.yml | grep domain | awk '{print $2}')
host=$(cat /etc/hosts | grep $domain | awk '{print $1}')

cat << EOF | kubectl apply -f -
apiVersion: v1
data:
  Corefile: |
    .:53 {
        errors
        health {
           lameduck 5s
        }
        hosts {
           $host $domain

           fallthrough
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        prometheus :9153
        forward . 114.114.114.114 {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
EOF
kubectl delete pod -n kube-system -l k8s-app=kube-dns
