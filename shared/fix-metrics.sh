#!/bin/bash

TOP=$(git rev-parse --show-toplevel)

kubectl replace -f "$TOP/shared/heapster-role.yaml"
