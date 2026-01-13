#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=argocd packageName=argoproj/argo-cd versioning=semver
ARGOCD_VERSION=3.2.4
# renovate: datasource=github-releases depName=dapr-cli packageName=dapr/cli versioning=semver
DAPR_VERSION=1.16.5
# renovate: datasource=github-releases depName=helm packageName=helm/helm versioning=semver
HELM_VERSION=4.0.4
# renovate: datasource=github-releases depName=k9s packageName=derailed/k9s versioning=semver
K9S_VERSION=0.50.18
# renovate: datasource=github-releases depName=talos packageName=siderolabs/talos versioning=semver
TALOS_VERSION=1.12.1
APT_PACKAGES=(
    'kubectl'
)

install_helm() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' '386' 'loong64' 'ppc64le' 'riscv64' 's390x')"
    local archive_file='/tmp/helm.tar.gz'
    curl -sSfL -o "${archive_file}" "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${arch}.tar.gz"
    tar -xzf "${archive_file}" -C /usr/local/bin --strip-components=1 "linux-${arch}/helm"
    rm -f "${archive_file}"

    helm completion bash >/usr/local/share/bash-completion/completions/helm
    helm completion zsh >/usr/local/share/zsh/site-functions/_helm
}

install_argocd() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm64' 'ppc64le' 's390x')"
    local binary='/tmp/argocd'
    curl -sSfL -o "${binary}" "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${arch}"
    install -m 555 "${binary}" /usr/local/bin/argocd
    rm "${binary}"

    argocd completion bash >/usr/local/share/bash-completion/completions/argocd
    argocd completion zsh >/usr/local/share/zsh/site-functions/_argocd
}

install_dapr() {
    local install_script='/tmp/install_dapr.sh'
    curl -sSfL -o "${install_script}" "https://raw.githubusercontent.com/dapr/cli/refs/tags/v${DAPR_VERSION}/install/install.sh"
    bash "${install_script}" "${DAPR_VERSION}"
    rm -f "${install_script}"

    dapr completion bash >/usr/local/share/bash-completion/completions/dapr
    dapr completion zsh >/usr/local/share/zsh/site-functions/_dapr
}

install_talos() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm64' 'armv7' 'riscv64')"
    local binary='/tmp/talos'
    curl -sSfL -o "${binary}" "https://github.com/siderolabs/talos/releases/download/v${TALOS_VERSION}/talosctl-linux-${arch}"
    install -m 555 "${binary}" /usr/local/bin/talosctl
    rm "${binary}"

    talosctl completion bash >/usr/local/share/bash-completion/completions/talosctl
    talosctl completion zsh >/usr/local/share/zsh/site-functions/_talosctl
}

install_k9s() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' 'armv7' 'ppc64le' 's390x')"
    local deb_file='/tmp/k9s.deb'
    curl -sSfL -o "${deb_file}" "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_linux_${arch}.deb"
    dpkg -i "${deb_file}"
    rm -f "${deb_file}"
}

base__apt_install "${APT_PACKAGES[@]}"
install_helm
install_argocd
install_dapr
install_talos
install_k9s
