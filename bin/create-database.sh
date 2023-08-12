#!/bin/bash

set -e

NAME=tap-demo-liquibase-db

tanzu services claass-claim get "$NAME" || tanzu services class-claim \
    create "$NAME" \
    --class postgresql-unmanaged
