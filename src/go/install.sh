#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=golangci-lint packageName=golangci/golangci-lint versioning=semver
GOLANGCI_LINT_VERSION=2.8.0
# renovate: datasource=github-releases depName=goreleaser packageName=goreleaser/goreleaser versioning=semver
GORELEASER_VERSION=2.13.3

APT_PACKAGES=(
    'golang'
)

install_golangci_lint() {
    local install_script='/tmp/install-golangci-lint.sh'
    curl -sSfL -o "${install_script}" "https://raw.githubusercontent.com/golangci/golangci-lint/refs/tags/v${GOLANGCI_LINT_VERSION}/install.sh"
    sh "${install_script}" -b /usr/local/bin "v${GOLANGCI_LINT_VERSION}"
    rm "${install_script}"
}

install_goreleaser() {
    local arch # One of: amd64, armhf, i386, loong64, ppc64, riscv64
    arch=$(dpkg --print-architecture)
    local deb_file='/tmp/goreleaser.deb'
    curl -sSfL -o "${deb_file}" "https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_${GORELEASER_VERSION}_${arch}.deb"
    dpkg -i "${deb_file}"
    rm "${deb_file}"
}

main() {
    base__apt_install "${APT_PACKAGES[@]}"
    install_golangci_lint
    install_goreleaser
}

main "$@"
