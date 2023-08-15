#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

"$SCRIPT_DIR/tap-sandbox-patches.sh"
"$SCRIPT_DIR/create-database.sh"
"$SCRIPT_DIR/configure-supply-chain.sh"
"$SCRIPT_DIR/configure-workload.sh"
