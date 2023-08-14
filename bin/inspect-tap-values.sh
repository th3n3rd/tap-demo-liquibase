#!/bin/bash

set -e

tanzu package installed get tap -n tap-install --values
