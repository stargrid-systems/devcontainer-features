#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=opentofu packageName=opentofu/opentofu versioning=semver
OPENTOFU_VERSION=1.11.2

install_opentofu() {
    local arch # One of: 386, amd64, arm, arm64
    arch="$(dpkg --print-architecture)"
    local url
    url="https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_${arch}.deb"

    curl -fsSL "$url" -o opentofu.deb
    dpkg -i opentofu.deb
    rm -f opentofu.deb
}

main() {
    install_opentofu
}

main "$@"
