#!/bin/bash

set -e

TAP_GUI_URL=$(kubectl get httpproxy tap-gui -n tap-gui -o yaml | yq '.spec.virtualhost.fqdn' | tr -d '\n')
echo "https://$TAP_GUI_URL"
