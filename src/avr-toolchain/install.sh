#!/usr/bin/env bash
set -euo pipefail


# renovate: datasource=github-releases depName=avrdude packageName=avrdudes/avrdude versioning=semver-coerced
AVRDUDE_VERSION=v8.1
# renovate: datasource=crate packageName=ravedude versioning=semver
RAVEDUDE_VERSION=0.2.2

APT_PACKAGES=(
    'avr-libc'
    'gcc-avr'
    'gcc'
    'libc6-dev'
)
CARGO_BINSTALL_PACKAGES=(
    "ravedude@${RAVEDUDE_VERSION}"
)

apt_install() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends "$@"
}

cargo_binstall() {
    cargo-binstall \
        --no-confirm \
        --strategies "crate-meta-data,quick-install" \
        --install-path "/usr/local/bin" \
        "$@"
}

install_avrdude() {
    # One of Linux_32bit, Linux_64bit, Linux_ARMv6, Linux_ARM64
    arch=$(dpkg --print-architecture)
    case "${arch}" in
    'amd64') arch='Linux_64bit' ;;
    'armhf') arch='Linux_ARMv6' ;;
    'arm64') arch='Linux_ARM64' ;;
    *)
        echo >&2 "Unsupported architecture: ${arch}"
        exit 1
        ;;
    esac
    url="https://github.com/avrdudes/avrdude/releases/download/${AVRDUDE_VERSION}/avrdude_${AVRDUDE_VERSION}_${arch}.tar.gz"
    curl -L -o /tmp/avrdude.tar.gz "${url}"
    tar -xzf /tmp/avrdude.tar.gz -C /usr/local --strip-components=1
    rm /tmp/avrdude.tar.gz
}

main() {
    apt_install "${APT_PACKAGES[@]}"
    cargo_binstall "${CARGO_BINSTALL_PACKAGES[@]}"
    install_avrdude
}

main "$@"
