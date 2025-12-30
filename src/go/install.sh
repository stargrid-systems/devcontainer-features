#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=golangci-lint packageName=golangci/golangci-lint versioning=semver
GOLANGCI_LINT_VERSION=2.7.2
# renovate: datasource=github-releases depName=goreleaser packageName=goreleaser/goreleaser versioning=semver
GORELEASER_VERSION=2.13.2

APT_PACKAGES=(
    'golang'
)

install_golangci_lint() {
    curl -sSfL https://golangci-lint.run/install.sh -o /tmp/install.sh
    sh /tmp/install.sh -b /usr/local/bin "v${GOLANGCI_LINT_VERSION}"
    rm /tmp/install.sh
}

install_goreleaser() {
    local arch # One of: amd64, armhf, i386, loong64, ppc64, riscv64
    arch=$(dpkg --print-architecture)
    local url
    url="https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_${GORELEASER_VERSION}_${arch}.deb"

    curl -sSL "$url" -o /tmp/goreleaser.deb
    dpkg -i /tmp/goreleaser.deb
    rm /tmp/goreleaser.deb
}

main() {
    base__apt_install "${APT_PACKAGES[@]}"
    install_golangci_lint
    install_goreleaser
}

main "$@"
