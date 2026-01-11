#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=npm packageName=markdownlint-cli2
MARKDOWNLINT_CLI2_VERSION=0.20.0

NPM_PACKAGES=(
    "markdownlint-cli2@${MARKDOWNLINT_CLI2_VERSION}"
)

base__npm_install "${NPM_PACKAGES[@]}"
