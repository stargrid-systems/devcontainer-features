#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=npm packageName=release-please
RELEASE_PLEASE_VERSION=17.1.3

NPM_PACKAGES=(
    "release-please@${RELEASE_PLEASE_VERSION}"
)

base__npm_install "${NPM_PACKAGES[@]}"
