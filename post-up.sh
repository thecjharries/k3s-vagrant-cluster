#!/bin/bash

CURRENT_DIR="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export KUBECONFIG="${CURRENT_DIR}/kubeconfig"

NON_MAIN_NODES=( $(kubectl get node --selector='!node-role.kubernetes.io/master' --output=jsonpath={.items..metadata.name}) )

kubectl label --overwrite node k3s-main node-role.kubernetes.io/master=true
kubectl taint --overwrite node k3s-main node-role.kubernetes.io/master=effect:NoSchedule

for node in ${NON_MAIN_NODES[@]}; do
    kubectl label --overwrite node $node 'node-role.kubernetes.io/node='
done
