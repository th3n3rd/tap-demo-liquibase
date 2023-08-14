#!/bin/bash

set -e

function error() {
    echo "$1" 1>&2
    exit 1
}

POD_MAX_MEMORY=$(kubectl get clusterpolicy sandbox-namespace-limits -o yaml | yq '.spec.rules[1].generate.data.spec.limits[] | select(.type =="Pod") | .max.memory ' | tr -d '\n')
if [ "$POD_MAX_MEMORY" != "2Gi" ]; then
    error "The Pod max memory should be set at least to 2Gi, instead was $POD_MAX_MEMORY"
fi

if ! kubectl get secret tap-gitops-ssh-auth > /dev/null; then
    error "The 'tap-gitops-ssh-auth' secret should exist"
fi

if ! kubectl get sa default -o yaml | yq '.secrets[] | select(.name == "tap-gitops-ssh-auth")' > /dev/null; then
    echo "Patching the service account via namespace provisioner annotations to include the tap-gitops-ssh-auth secret"
    kubectl annotate --overwrite ns apps param.nsp.tap/supply_chain_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
    kubectl annotate --overwrite ns apps param.nsp.tap/delivery_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
fi

KNATIVE_INITCONTAINERS=$(kubectl get cm config-features -n knative-serving -o yaml | yq '.data["kubernetes.podspec-init-containers"]')
if [ "$KNATIVE_INITCONTAINERS" != "enabled" ]; then
    error "The Knative init containers feature flag should be set to 'enabled', instead was $KNATIVE_INITCONTAINERS"
fi

echo "Everything is ready! setup the cluster"
