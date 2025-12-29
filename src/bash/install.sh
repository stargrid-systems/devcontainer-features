#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

APT_PACKAGES=(
    'shellcheck'
    'shfmt'
)

base__apt_install "${APT_PACKAGES[@]}"
