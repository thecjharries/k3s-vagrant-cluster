#!/bin/bash

CURRENT_DIR="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export KUBECONFIG="${CURRENT_DIR}/kubeconfig"

istioctl operator init \
    --hub docker.io/istio \
    --operatorNamespace istio-operator \
    --tag 1.6.2 \
    --istioNamespace istio-system
