#!/bin/bash

NAMESPACE=$(kubectl config current-context)

BRANCH="master"
if [[ $NAMESPACE == *staging* ]]; then
  BRANCH="staging"
fi

helm repo add fluxcd https://fluxcd.github.io/flux
helm upgrade flux fluxcd/flux \
  --install \
  --set rbac.create=true \
  --set helmOperator.create=true \
  --set helmOperator.createCRD=true \
  --set git.url=git@github.com:travis-ci/kubernetes-config.git \
  --set git.branch="$BRANCH" \
  --set "git.path=releases/$NAMESPACE" \
  --set git.pollInterval=1m \
  --set git.label="flux-sync-$NAMESPACE" \
  --namespace flux
