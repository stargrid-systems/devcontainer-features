#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=cosign packageName=sigstore/cosign versioning=semver
COSIGN_VERSION=3.0.4

install_cosign() {
    local arch
    arch=$(base__pick_architecture 'amd64' 'arm64' 'armhf' 'ppc64el' 'riscv64' 's390x')
    local deb_file='/tmp/cosign.deb'
    curl -sSfL -o "${deb_file}" "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_${arch}.deb"
    dpkg -i "${deb_file}"
    rm "${deb_file}"

    cosign completion bash >/usr/local/share/bash-completion/completions/cosign
    cosign completion zsh >/usr/local/share/zsh/site-functions/_cosign
}

install_cosign
