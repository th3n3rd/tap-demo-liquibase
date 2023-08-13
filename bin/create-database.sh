#!/bin/bash

set -e

NAME=tap-demo-liquibase-db

tanzu services class-claim get "$NAME" || tanzu services class-claim \
    create "$NAME" \
    --class postgresql-unmanaged
