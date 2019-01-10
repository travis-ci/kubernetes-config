#!/bin/bash

TOP=$(git rev-parse --show-toplevel)
helm upgrade worker-operator "$TOP/charts/worker-operator" \
  --install \
  --set image.tag=v1.0.0
