#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

APT_PACKAGES=(
    'golang'
)

main() {
    base__apt_install "${APT_PACKAGES[@]}"
}

main "$@"
