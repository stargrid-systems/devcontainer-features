#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=butane packageName=coreos/butane versioning=semver
BUTANE_VERSION=0.25.1
# renovate: datasource=github-releases depName=hcloud packageName=hetznercloud/cli versioning=semver
HCLOUD_VERSION=1.60.0
# renovate: datasource=github-releases depName=opentofu packageName=opentofu/opentofu versioning=semver
OPENTOFU_VERSION=1.11.4
# renovate: datasource=github-releases depName=packer packageName=hashicorp/packer versioning=semver
PACKER_VERSION=1.14.3
# renovate: datasource=github-releases depName=terraform packageName=hashicorp/terraform versioning=semver
TERRAFORM_VERSION=1.14.3

handle_posener_complete() {
    local binary="${1:?}"
    local full_path
    full_path="$(command -v "${binary}")"

    # For bash
    # See: <https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L18-L24>
    # complete -C </path/to/completion/command> <command>
    local bash_script="/usr/local/share/bash-completion/completions/${binary}"
    echo "complete -C ${full_path} ${binary}" >"${bash_script}"

    # For zsh
    # See: <https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/zsh.go#L5-L9>
    # autoload -U +X bashcompinit && bashcompinit
    # complete -C </path/to/completion/command> <command>
    local zsh_script="/usr/local/share/zsh/site-functions/_${binary}"
    echo "autoload -U +X bashcompinit && bashcompinit" >"${zsh_script}"
    echo "complete -C ${full_path} ${binary}" >>"${zsh_script}"
}

install_opentofu() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' '386')"
    local deb_file='/tmp/opentofu.deb'
    curl -sSfL -o "${deb_file}" "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_${arch}.deb"
    dpkg -i "${deb_file}"
    rm -f "${deb_file}"

    handle_posener_complete tofu
}

install_hashicorp_binary() {
    local binary="${1:?}"
    local version="${2:?}"
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' '386')"
    local zip_file="/tmp/${binary}.zip"
    curl -sSfL -o "${zip_file}" "https://releases.hashicorp.com/${binary}/${version}/${binary}_${version}_linux_${arch}.zip"
    unzip -q "${zip_file}" -d /usr/local/bin "${binary}"
    rm -f "${zip_file}"

    handle_posener_complete "${binary}"
}

install_hcloud() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'armv6' 'armv7' '386')"
    local archive_file='/tmp/hcloud.tar.gz'
    curl -sSfL -o "${archive_file}" "https://github.com/hetznercloud/cli/releases/download/v${HCLOUD_VERSION}/hcloud-linux-${arch}.tar.gz"
    tar -C /usr/local/bin -xzf "${archive_file}" hcloud
    rm -f "${archive_file}"

    hcloud completion bash >/usr/local/share/bash-completion/completions/hcloud
    hcloud completion zsh >/usr/local/share/zsh/site-functions/_hcloud
}

install_butane() {
    local public_key='/tmp/fedora.gpg'
    curl -sSfL -o "${public_key}" 'https://fedoraproject.org/fedora.gpg'

    local arch
    arch="$(base__pick_architecture 'aarch64' 'ppc64le' 's390x' 'x86_64')"
    local binary_file='/tmp/butane'
    local binary_url="https://github.com/coreos/butane/releases/download/v${BUTANE_VERSION}/butane-${arch}-unknown-linux-gnu"
    curl -sSfL -o "${binary_file}" "${binary_url}"
    curl -sSfL -o "${binary_file}.asc" "${binary_url}.asc"
    gpg --keyring "${public_key}" --verify "${binary_file}.asc" "${binary_file}"
    install -m 755 "${binary_file}" /usr/local/bin/butane
    rm -f "${binary_file}" "${binary_file}.asc" "${public_key}"
}

install_opentofu
install_hashicorp_binary terraform "${TERRAFORM_VERSION}"
install_hashicorp_binary packer "${PACKER_VERSION}"
install_hcloud
install_butane
