#!/bin/bash

TOP=$(git rev-parse --show-toplevel)
ENDPOINT="$1"

helm install "$TOP/charts/papertrail" \
  --set "endpoint=$ENDPOINT" \
  --name papertrail \
  --namespace kube-system
