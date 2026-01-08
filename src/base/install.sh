#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./library.sh
source ./library.sh

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainers/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.6
# renovate: datasource=github-releases depName=uv packageName=astral-sh/uv versioning=semver
UV_VERSION=0.9.22
APT_PACKAGES=(
    'ca-certificates'
    'curl'
    'git'
    'npm'
    'sudo'
)

install_cargo_binstall() {
    declare -x BINSTALL_VERSION="${CARGO_BINSTALL_VERSION}"
    declare -x CARGO_HOME='/usr/local'
    curl -L -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh -o /tmp/cargo-binstall-install.sh
    bash /tmp/cargo-binstall-install.sh
    rm /tmp/cargo-binstall-install.sh
}

install_uv() {
    declare -x UV_INSTALL_DIR='/usr/local/bin'
    curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" -o /tmp/uv-install.sh
    sh /tmp/uv-install.sh --no-modify-path
    rm /tmp/uv-install.sh
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
    install_uv
}

main "$@"
