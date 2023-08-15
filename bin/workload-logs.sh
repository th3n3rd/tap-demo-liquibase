#!/bin/bash

set -e

tanzu apps workload tail tap-demo-liquibase --component run "$@"
