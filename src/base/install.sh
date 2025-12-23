#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./library.sh
source ./library.sh

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainer-features/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.5
APT_PACKAGES=(
    'ca-certificates'
    'curl'
    'rustup'
)

install_cargo_binstall() {
    export BINSTALL_VERSION="${CARGO_BINSTALL_VERSION}"
    export CARGO_HOME='/usr/local'
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}

install_scripts() {
    mkdir -p "${TARGET_SCRIPTS_DIR}"
    cp library.sh oncreate.sh "${TARGET_SCRIPTS_DIR}"
}

main() {
    install_scripts
    base__apt_install "${APT_PACKAGES[@]}"
    install_cargo_binstall
}

main "$@"
