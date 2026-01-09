#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=oras packageName=oras-project/oras versioning=semver
ORAS_VERSION=1.3.0

install_oras() {
    local arch
    arch=$(dpkg --print-architecture)
    local archive_file='/tmp/oras.tar.gz'
    curl -sSfL -o "${archive_file}" "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${arch}.tar.gz"
    tar -xzf "${archive_file}" -C /usr/local/bin oras
    rm "${archive_file}"
    chmod +x /usr/local/bin/oras
}

install_oras
