#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

"$SCRIPT_DIR/patch-service-accounts.sh"
"$SCRIPT_DIR/create-supply-chain.sh"
"$SCRIPT_DIR/create-database.sh"
"$SCRIPT_DIR/reapply-workload.sh"
