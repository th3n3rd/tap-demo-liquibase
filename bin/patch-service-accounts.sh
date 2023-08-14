#!/bin/bash

set -e

echo "Adding gitops secret by patching the service account via namespace provisioner annotations"
kubectl annotate --overwrite ns apps param.nsp.tap/supply_chain_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
kubectl annotate --overwrite ns apps param.nsp.tap/delivery_service_account.secrets='["registries-credentials", "tap-gitops-ssh-auth"]'
