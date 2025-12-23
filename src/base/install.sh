#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt_packages=(
    'curl'
    'ca-certificates'
)
apt-get update
apt-get install -y --no-install-recommends "${apt_packages[@]}"

# TODO(renovate): track
export BINSTALL_VERSION='1.16.3'
export CARGO_HOME='/usr/local'
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
