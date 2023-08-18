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
    info "Manual fix: create a kubernetes secret named 'tap-gitops-ssh-auth' for git authentication over SSH, following the specs here https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/scc-git-auth.html#ssh-2"
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

TEKTON_RESULTS_FROM=$(kubectl get cm feature-flags -n tekton-pipelines -o yaml | yq '.data["results-from"]')
if [ "$TEKTON_RESULTS_FROM" != "sidecar-logs" ]; then
    error "The Tekton results sidecar should be enabled"
    info "Patching the configuration map"
    kubectl get cm feature-flags -n tekton-pipelines -o yaml \
        | yq '.data += { "results-from": "sidecar-logs" }' \
        | kubectl apply -f -
else
    success "The Tekton results sidecar-logs is enabled"
fi

TEKTON_RESULTS_SIZE=$(kubectl get cm feature-flags -n tekton-pipelines -o yaml | yq '.data["max-result-size"]')
if [ "$TEKTON_RESULTS_SIZE" != "1048576" ]; then
    error "The Tekton results sidecar should be set to 1048576 (i.e. 1MiB), instead was $TEKTON_RESULTS_SIZE"
    info "Patching the configuration map"
    kubectl get cm feature-flags -n tekton-pipelines -o yaml \
        | yq '.data += { "max-result-size": "1048576" }' \
        | kubectl apply -f -
else
    success "The Tekton max results size is configured to 1048576 (i.e. 1MiB)"
fi

echo "Everything is ready! You can now setup the supply chain and workload"
