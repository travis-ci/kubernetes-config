#!/bin/bash

NAMESPACE=$(kubectl config current-context)

helm repo add weaveworks https://weaveworks.github.io/flux
helm upgrade flux weaveworks/flux \
  --set rbac.create=true \
  --set helmOperator.create=true \
  --set git.url=ssh://git@github.com/travis-ci/kubernetes-config.git \
  --set "git.path=releases/$NAMESPACE" \
  --set git.chartsPath=charts \
  --set git.pollInterval=1m \
  --namespace flux
