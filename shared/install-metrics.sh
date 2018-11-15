#!/bin/bash

TOP=$(git rev-parse --show-toplevel)

helm upgrade heapster stable/heapster \
  -i \
  --namespace kube-system \
  --values "$TOP/shared/heapster-values.yaml"

kubectl replace -f "$TOP/shared/heapster-role.yaml"
