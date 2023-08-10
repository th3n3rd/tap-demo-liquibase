#!/bin/bash

set -e

NS=tap-demo-liquibase-db-qvfrb

echo -n "Username: "
kubectl -n $NS \
    get secret tap-demo-liquibase-db-qvfrb \
    -o yaml | yq '.data.username' | base64 -d

echo
echo -n "Password: "
kubectl -n $NS \
    get secret tap-demo-liquibase-db-qvfrb \
    -o yaml | yq '.data.password' | base64 -d

echo
echo -n "Database: "
kubectl -n $NS \
    get secret tap-demo-liquibase-db-qvfrb \
    -o yaml | yq '.data.database' | base64 -d

echo
kubectl -n $NS \
    port-forward svc/tap-demo-liquibase-db-qvfrb \
    5432:5432
