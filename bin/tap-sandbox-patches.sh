#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "$SCRIPT_DIR/utils.sh"

POD_MAX_MEMORY=$(kubectl get clusterpolicy sandbox-namespace-limits -o yaml | yq '.spec.rules[1].generate.data.spec.limits[] | select(.type =="Pod") | .max.memory ' | tr -d '\n')
if [ "$POD_MAX_MEMORY" != "2Gi" ]; then
    error "The Pod max memory should be set at least to 2Gi, instead was $POD_MAX_MEMORY"
    info "Patching the cluster policy"
    kubectl get clusterpolicy sandbox-namespace-limits -o yaml \
        | yq eval '(.spec.rules[] | select(.name == "deploy-limit-ranges") .generate.data.spec.limits[] | select(.type == "Pod") .max.memory) = "2Gi"' - \
        | kubectl apply -f -
else
    success "Pod max memory correctly set"
fi

if ! kubectl get secret tap-gitops-ssh-auth &> /dev/null; then
    error "The gitops secret should exist"
    info "Manual fix: create a kubernetes secret named 'tap-gitops-ssh-auth' for git authentication over SSH, following the specs here https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/scc-git-auth.html#sh"
    fail
else
    success "The gitops secret exists"
fi

SERVICE_ACCOUNT_SECRET=$(kubectl get sa default -o yaml | yq '.secrets[] | select(.name == "tap-gitops-ssh-auth") | .name' | tr -d '\n')
if [ "$SERVICE_ACCOUNT_SECRET" != "tap-gitops-ssh-auth" ]; then
    error "The gitops secret should be associated with the default service account"
    info "Patching the service account via namespace provisioner annotations to include the tap-gitops-ssh-auth secret"
    kubectl annotate --overwrite ns apps param.nsp.tap/supply_chain_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
    kubectl annotate --overwrite ns apps param.nsp.tap/delivery_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
else
    success "The gitops secret is associated with the default service account"
fi

KNATIVE_INITCONTAINERS=$(kubectl get cm config-features -n knative-serving -o yaml | yq '.data["kubernetes.podspec-init-containers"]')
if [ "$KNATIVE_INITCONTAINERS" != "enabled" ]; then
    error "The Knative init containers feature flag should be enabled, instead was $KNATIVE_INITCONTAINERS"
    info "Patching the configuration map"
    kubectl get cm config-features -n knative-serving -o yaml \
        | yq '.data += { "kubernetes.podspec-init-containers": "enabled" }' \
        | kubectl apply -f -
    fail
else
    success "The Knative init containers feature flag is enabled"
fi

echo "Everything is ready! You can now setup the supply chain and workload"
