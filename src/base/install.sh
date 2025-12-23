#!/usr/bin/env bash
set -euo pipefail

LIFECYCLE_DIR='/usr/local/share/devcontainer-features/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.3
APT_PACKAGES=(
    'ca-certificates'
    'curl'
    'rustup'
)

apt_install() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends "$@"
}

install_cargo_binstall() {
    export BINSTALL_VERSION="${CARGO_BINSTALL_VERSION}"
    export CARGO_HOME='/usr/local'
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}

install_lifecycle_scripts() {
    mkdir -p "${LIFECYCLE_DIR}"
    cp oncreate.sh "${LIFECYCLE_DIR}/oncreate.sh"
}

main() {
    apt_install "${APT_PACKAGES[@]}"
    install_cargo_binstall
    install_lifecycle_scripts
}

main "$@"
