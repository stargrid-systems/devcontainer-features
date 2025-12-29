#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./library.sh
source ./library.sh

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainers/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.6
APT_PACKAGES=(
    'ca-certificates'
    'curl'
    'git'
    'sudo'
)

install_cargo_binstall() {
    declare -x BINSTALL_VERSION="${CARGO_BINSTALL_VERSION}"
    declare -x CARGO_HOME='/usr/local'
    curl -L -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}

install_scripts() {
    mkdir -p "${TARGET_SCRIPTS_DIR}"
    cp library.sh "${TARGET_SCRIPTS_DIR}"
}

main() {
    install_scripts
    base__apt_install "${APT_PACKAGES[@]}"
    # Since we're likely the first feature to install apt packages, let's clean up the system while we're here
    apt-get -y upgrade --no-install-recommends
    apt-get autoremove -y

    install_cargo_binstall
}

main "$@"
