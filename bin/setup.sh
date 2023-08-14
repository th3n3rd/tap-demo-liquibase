#!/bin/bash

set -e

function error() {
    echo $1
    exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

"$SCRIPT_DIR/tap-sandbox-patches.sh"
"$SCRIPT_DIR/create-supply-chain.sh"
"$SCRIPT_DIR/create-database.sh"
"$SCRIPT_DIR/reapply-workload.sh"
