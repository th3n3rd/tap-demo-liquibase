#!/bin/bash

set -e

echo "The max memory for a Pod should be set at least to 2Gi (i.e. > 2048M)"
kubectl get clusterpolicy sandbox-namespace-limits -o yaml | yq '.spec.rules[1].generate.data'
