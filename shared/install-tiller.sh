#!/bin/bash

CONTEXT="$1"

kubectl create serviceaccount tiller \
  --context "$CONTEXT" \
  --namespace kube-system

kubectl create clusterrolebinding tiller-cluster-role \
  --context "$CONTEXT" \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --skip-refresh --upgrade \
  --service-account tiller \
  --kube-context "$CONTEXT"
