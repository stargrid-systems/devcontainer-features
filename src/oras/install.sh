#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=oras packageName=oras-project/oras versioning=semver
ORAS_VERSION=1.3.0

install_oras() {
    local arch
    arch=$(dpkg --print-architecture)
    local url="https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${arch}.tar.gz"
    
    curl -fsSL -o /tmp/oras.tar.gz "$url"
    tar -xzf /tmp/oras.tar.gz -C /usr/local/bin oras
    chmod +x /usr/local/bin/oras
    rm /tmp/oras.tar.gz
}

install_oras
