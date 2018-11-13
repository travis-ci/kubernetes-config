#!/bin/bash

helm repo add weaveworks https://weaveworks.github.io/flux
helm install --name flux \
  --set rbac.create=true \
  --set helmOperator.create=true \
  --set git.url=ssh://git@github.com/travis-ci/kubernetes-config.git \
  --set git.branch=mjm-flux \
  --set git.chartsPath=charts \
  --namespace flux \
  weaveworks/flux
