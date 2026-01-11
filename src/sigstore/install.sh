#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=cosign packageName=sigstore/cosign versioning=semver
COSIGN_VERSION=3.0.4
# renovate: datasource=github-releases depName=gitsign packageName=sigstore/gitsign versioning=semver
GITSIGN_VERSION=0.13.0
# renovate: datasource=github-releases depName=rekor-cli packageName=sigstore/rekor-cli versioning=semver
REKOR_CLI_VERSION=1.4.3


install_cosign() {
    local arch
    arch=$(base__pick_architecture 'amd64' 'arm64' 'armhf' 'ppc64el' 'riscv64' 's390x')
    local deb_file='/tmp/cosign.deb'
    local url="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_${arch}.deb"
    curl -sSfL -o "${deb_file}" "${url}"
    curl -sSfL -o "${deb_file}.sigstore.json" "${url}.sigstore.json"
    dpkg -i "${deb_file}"
    # Now that cosign is installed, use it to verify its own package
    cosign verify-blob "${deb_file}" --bundle "${deb_file}.sigstore.json" \
        --certificate-identity 'keyless@projectsigstore.iam.gserviceaccount.com' \
        --certificate-oidc-issuer 'https://accounts.google.com'
    rm "${deb_file}" "${deb_file}.sigstore.json"

    cosign completion bash >/usr/local/share/bash-completion/completions/cosign
    cosign completion zsh >/usr/local/share/zsh/site-functions/_cosign
}

install_rekor_cli() {
    local arch
    arch=$(base__pick_architecture 'amd64' 'arm64' 'arm' 'ppc64le' 's390x')
    local binary='/tmp/rekor-cli'
    local url="https://github.com/sigstore/rekor/releases/download/v${REKOR_CLI_VERSION}/rekor-cli-linux-${arch}"
    curl -sSfL -o "${binary}" "${url}"
    curl -sSfL -o "${binary}-keyless.sigstore.json" "${url}-keyless.sigstore.json"
    cosign verify-blob "${binary}" --bundle "${binary}-keyless.sigstore.json" \
        --certificate-identity 'keyless@projectsigstore.iam.gserviceaccount.com' \
        --certificate-oidc-issuer 'https://accounts.google.com'
    install -m 755 "${binary}" /usr/local/bin/rekor-cli
    rm -f "${binary}-keyless.sigstore.json" "${binary}"

    rekor-cli completion bash >/usr/local/share/bash-completion/completions/rekor-cli
    rekor-cli completion zsh >/usr/local/share/zsh/site-functions/_rekor-cli
}

install_gitsign() {
    local arch
    arch=$(base__pick_architecture 'amd64' 'arm64')
    local deb_file='/tmp/gitsign.deb'
    local url="https://github.com/sigstore/gitsign/releases/download/v${GITSIGN_VERSION}/gitsign_${GITSIGN_VERSION}_linux_${arch}.deb"
    curl -sSfL -o "${deb_file}" "${url}"
    dpkg -i "${deb_file}"
    # TODO: verify??
    rm "${deb_file}"

    gitsign completion bash >/usr/local/share/bash-completion/completions/gitsign
    gitsign completion zsh >/usr/local/share/zsh/site-functions/_gitsign
}

install_cosign
install_rekor_cli
install_gitsign
