#!/bin/bash

set -e

kubectl -n cartographer-system logs deploy/cartographer-controller "$@"
