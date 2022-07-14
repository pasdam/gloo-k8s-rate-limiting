#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$( dirname "$0" )" >/dev/null && pwd )"

NS=gloo-test

# install gloo
helm repo add gloo https://storage.googleapis.com/solo-public-helm
helm repo update
helm upgrade --install gloo gloo/gloo \
  --version "1.11.12" \
  --create-namespace \
  --namespace $NS \
  --values $SCRIPT_DIR/gloo/helm-values.yaml \
  --wait --timeout 300s
kubectl patch settings default -n $NS --type merge --patch "$(cat $SCRIPT_DIR/gloo/patch-settings.yaml)"

# install backend service
kubectl apply -f https://raw.githubusercontent.com/solo-io/gloo/master/example/petstore/petstore.yaml

# install redis
kubectl apply -f $SCRIPT_DIR/redis/deployment.yaml
kubectl apply -f $SCRIPT_DIR/redis/service.yaml

# install rate limit service
kubectl apply -f $SCRIPT_DIR/ratelimit/configmap.yaml
kubectl apply -f $SCRIPT_DIR/ratelimit/deployment.yaml
kubectl apply -f $SCRIPT_DIR/ratelimit/service.yaml

# configure Gloo
kubectl apply -f $SCRIPT_DIR/petstore/upstream.yaml
kubectl apply -f $SCRIPT_DIR/ratelimit/upstream.yaml
kubectl apply -f $SCRIPT_DIR/gloo/virtual-service.yaml
