#!/bin/bash

set -e

BINDING_NAME=$(kubectl get classclaim tap-demo-liquibase-db -o yaml | yq '.status.binding.name' | tr -d '\n')

echo -n "Username: "
kubectl get secret "$BINDING_NAME" \
    -o yaml | yq '.data.username' | base64 -d

echo
echo -n "Password: "
kubectl get secret "$BINDING_NAME" \
    -o yaml | yq '.data.password' | base64 -d

echo
echo -n "Database: "
kubectl get secret "$BINDING_NAME" \
    -o yaml | yq '.data.database' | base64 -d

REFERENCE_NAME=$(kubectl get secret "$BINDING_NAME" -o yaml | yq '.metadata.ownerReferences[0].name' | tr -d '\n')

echo
kubectl -n "$REFERENCE_NAME" \
    port-forward "svc/$REFERENCE_NAME" \
    5432:5432
