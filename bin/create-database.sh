#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "$SCRIPT_DIR/utils.sh"

NAME=tap-demo-liquibase-db

if ! tanzu services class-claim get "$NAME" &> /dev/null; then
    error "Database not found"
    info "Creating a new PostgreSQL service named $NAME"
    tanzu services class-claim create "$NAME" --class postgresql-unmanaged
    success "Database '$NAME' created"
else
    success "Database '$NAME' exists"
fi
