#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "$SCRIPT_DIR/utils.sh"

info "Configuring the workload"
kubectl delete -f "$SCRIPT_DIR/../config/workload.yaml" &> /dev/null || true
kubectl apply -f "$SCRIPT_DIR/../config/workload.yaml" &> /dev/null
success "Workload configured"
info "Run: watch -n1 tanzu apps workload get tap-demo-liquibase"
