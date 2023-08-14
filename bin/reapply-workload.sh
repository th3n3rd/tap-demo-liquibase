#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

kubectl delete -f "$SCRIPT_DIR/../config/workload.yaml" || true
kubectl apply -f "$SCRIPT_DIR/../config/workload.yaml"
watch -n1 tanzu apps workload get tap-demo-liquibase
