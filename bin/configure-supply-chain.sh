#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "$SCRIPT_DIR/utils.sh"

TAP_VALES=$(tanzu package installed get tap --values -n tap-install)
REGISTRY_REPOSITORY=$(echo "$TAP_VALES" | yq -r '.ootb_supply_chain_basic.registry.repository' | tr -d '\n')
REGISTRY_SERVER=$(echo "$TAP_VALES" | yq -r '.ootb_supply_chain_basic.registry.server' | tr -d '\n')

info "Configuring 'source-db-migrations-to-url' supply chain"
kubectl apply -f "$SCRIPT_DIR/../config/supply-chain/deliverable-jobs-rbac.yaml"
kubectl apply -f "$SCRIPT_DIR/../config/supply-chain/liquibase-config-provider-template.yaml"
kubectl apply -f "$SCRIPT_DIR/../config/supply-chain/liquibase-config-template.yaml"
kubectl apply -f "$SCRIPT_DIR/../config/supply-chain/enhanced-web-config-template.yaml"
ytt \
    --data-value registry.repository="$REGISTRY_REPOSITORY" \
    --data-value registry.server="$REGISTRY_SERVER" \
    -f "$SCRIPT_DIR/../config/supply-chain/custom-supply-chain.yaml" | kubectl apply -f -
success "Custom supply chain 'source-db-migrations-to-url' configured"
