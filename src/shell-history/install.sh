#!/usr/bin/env bash
set -euo pipefail

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainers/shell-history'

mkdir -p "${TARGET_SCRIPTS_DIR}"
cp oncreate.sh "${TARGET_SCRIPTS_DIR}"
