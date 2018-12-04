#!/bin/bash

NAMESPACE=$(kubectl config current-context)

BRANCH="master"
if [[ $NAMESPACE == *staging* ]]; then
  BRANCH="staging"
fi

helm repo add weaveworks https://weaveworks.github.io/flux
helm upgrade flux weaveworks/flux \
  --install \
  --set rbac.create=true \
  --set helmOperator.create=true \
  --set git.url=https://github.com/travis-ci/kubernetes-config.git \
  --set git.branch="$BRANCH" \
  --set "git.path=releases/$NAMESPACE" \
  --set git.pollInterval=1m \
  --namespace flux
