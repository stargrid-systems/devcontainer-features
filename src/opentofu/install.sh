#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=opentofu packageName=opentofu/opentofu versioning=semver
OPENTOFU_VERSION=1.11.2
# renovate: datasource=github-releases depName=terraform packageName=hashicorp/terraform versioning=semver
TERRAFORM_VERSION=1.14.3

install_opentofu() {
    local arch # One of: 386, amd64, arm, arm64
    arch="$(dpkg --print-architecture)"
    local deb_file='/tmp/opentofu.deb'
    curl -sSfL -o "${deb_file}" "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_${arch}.deb"
    dpkg -i "${deb_file}"
    rm -f "${deb_file}"
}

install_terraform() {
    local arch # Supported: 386, amd64, arm, arm64
    arch="$(dpkg --print-architecture | sed 's/i386/386/')"
    local zip_file='/tmp/terraform.zip'
    curl -sSfL -o "${zip_file}" "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${arch}.zip"
    unzip -q "${zip_file}" -d /usr/local/bin terraform
    rm -f "${zip_file}"
}

main() {
    # TODO: remove after next base feature release
    base__apt_install unzip
    install_opentofu
    install_terraform
}

main "$@"
