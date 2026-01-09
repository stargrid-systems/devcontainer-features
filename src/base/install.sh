#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./library.sh
source ./library.sh

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainers/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.6
# renovate: datasource=github-releases depName=uv packageName=astral-sh/uv versioning=semver
UV_VERSION=0.9.23
APT_PACKAGES=(
    'ca-certificates'
    'curl'
    'git'
    'npm'
    'sudo'
)

install_cargo_binstall() {
    local script_path='/tmp/cargo-binstall-install.sh'
    curl -sSfL -o "${script_path}" "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/refs/tags/v${CARGO_BINSTALL_VERSION}/install-from-binstall-release.sh"
    declare -x BINSTALL_VERSION="${CARGO_BINSTALL_VERSION}"
    declare -x CARGO_HOME='/usr/local'
    bash "${script_path}"
    rm "${script_path}"
}

install_uv() {
    local script_path='/tmp/uv-install.sh'
    curl -sSfL -o "${script_path}" "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-installer.sh"
    declare -x UV_INSTALL_DIR='/usr/local/bin'
    sh "${script_path}" --no-modify-path
    rm "${script_path}"
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
