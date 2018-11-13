#!/bin/bash

TOP=$(git rev-parse --show-toplevel)

helm install stable/kubernetes-dashboard \
  --values "$TOP/shared/macstadium-dashboard-values.yaml" \
  --name kubernetes-dashboard \
  --namespace kube-system
