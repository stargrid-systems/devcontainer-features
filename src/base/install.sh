#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=./library.sh
source ./library.sh

TARGET_SCRIPTS_DIR='/usr/local/share/devcontainer-features/base'

# renovate: datasource=github-releases depName=cargo-binstall packageName=cargo-bins/cargo-binstall versioning=semver
CARGO_BINSTALL_VERSION=1.16.5
APT_PACKAGES=(
    'bash-completion'
    'ca-certificates'
    'curl'
    'git'
    'gnupg'
    'make'
    'rustup'
    'sudo'
    'zsh'
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

prepare_dev_user() {
    if [ "${REMOTE_USER}" = "root" ]; then
        echo >&2 "REMOTE_USER must not be 'root'."
        exit 1
    fi

    # Create the user
    useradd \
        --home-dir "$_REMOTE_USER_HOME" \
        --gid "$_REMOTE_USER" \
        --groups 'sudo' \
        --create-home \
        --shell '/usr/bin/zsh' \
        "$_REMOTE_USER"
    # Allow passwordless sudo for the user
    echo "$_REMOTE_USER ALL=\(root\) NOPASSWD:ALL" >"/etc/sudoers.d/$_REMOTE_USER-sudo"
    chmod 0440 "/etc/sudoers.d/$_REMOTE_USER-sudo"
}

main() {
    install_scripts
    base__apt_install "${APT_PACKAGES[@]}"
    # Since we're likely the first feature to install apt packages, let's clean up the system while we're here
    apt-get -y upgrade --no-install-recommends
    apt-get autoremove -y

    install_cargo_binstall
    prepare_dev_user
}

main "$@"
