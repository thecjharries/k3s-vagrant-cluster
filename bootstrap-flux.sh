#!/bin/bash

CURRENT_DIR="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export KUBECONFIG="${CURRENT_DIR}/kubeconfig"

# https://docs.fluxcd.io/en/latest/tutorials/get-started-helm/
helm repo add fluxcd https://charts.fluxcd.io
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml
kubectl create namespace flux
helm upgrade -i flux fluxcd/flux \
    --set git.url=git@github.com:thecjharries/k3s-vagrant-cluster-flux \
    --set git.branch=main \
    --namespace flux

kubectl wait -n flux --for=condition=ready pod --all

# helm upgrade -i helm-operator fluxcd/helm-operator \
#     --set helm.versions=v3 \
#     --set git.ssh.secretName=flux-git-deploy \
#     --namespace flux

# kubectl wait --for=condition=ready pod -l app=helm-operator

# KEY_CONTENTS=$(kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2)

# curl -v -X POST \
#     -H "Authorization: token $GH_API_FLUX_DEPLOY" \
#     -H "User-Agent: thecjharries" \
#     -H 'Content-Type: application/json' \
#     -H 'Time-Zone: America/Chicago' \
#     -H 'Accept: application/vnd.github.v3+json' \
#     -d "{\"title\":\"flux-deploy\",\"key\":\"$KEY_CONTENTS\",\"read_only\":false}" \
#     https://api.github.com/repos/thecjharries/k3s-vagrant-cluster-flux/keys
