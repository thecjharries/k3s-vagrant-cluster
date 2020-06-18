#!/bin/bash

CURRENT_DIR="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export KUBECONFIG="${CURRENT_DIR}/kubeconfig"

istioctl install --set profile=demo

kubectl label namespace default istio-injection=enabled

kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml

kubectl wait --for=condition=ready pod -l 'app in (details, reviews, ratings, productpage)'

kubectl apply -f https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/networking/bookinfo-gateway.yaml

istioctl analyze

export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo $GATEWAY_URL
echo http://$GATEWAY_URL/productpage

istioctl dashboard kiali

istioctl manifest generate --set profile=demo | kubectl delete -f -
kubectl delete namespace istio-system
