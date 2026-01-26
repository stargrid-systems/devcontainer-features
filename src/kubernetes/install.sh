#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=argocd packageName=argoproj/argo-cd versioning=semver
ARGOCD_VERSION=3.2.6
# renovate: datasource=github-releases depName=cloudnative-pg packageName=cloudnative-pg/cloudnative-pg versioning=semver
CNPG_VERSION=1.28.0
# renovate: datasource=github-releases depName=dapr-cli packageName=dapr/cli versioning=semver
DAPR_VERSION=1.16.5
# renovate: datasource=github-releases depName=helm packageName=helm/helm versioning=semver
HELM_VERSION=4.1.0
# renovate: datasource=github-releases depName=k9s packageName=derailed/k9s versioning=semver
K9S_VERSION=0.50.18
# renovate: datasource=github-releases depName=krew packageName=kubernetes-sigs/krew versioning=semver
KREW_VERSION=0.4.5
# renovate: datasource=github-releases depName=kubeseal packageName=bitnami-labs/sealed-secrets versioning=semver
KUBESEAL_VERSION=0.34.0
# renovate: datasource=github-releases depName=talos packageName=siderolabs/talos versioning=semver
TALOS_VERSION=1.12.2
APT_PACKAGES=(
    'kubectl'
)

install_helm() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' '386' 'loong64' 'ppc64le' 'riscv64' 's390x')"
    local archive_file='/tmp/helm.tar.gz'
    curl -sSfL -o "${archive_file}" "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${arch}.tar.gz"
    tar -xzf "${archive_file}" -C /usr/local/bin --strip-components=1 "linux-${arch}/helm"
    rm "${archive_file}"

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
    rm "${install_script}"

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
    rm "${deb_file}"
}

# krew unfortunately uses the same flawed ideology as brew where you can't
# install specific versions of a tool. This means we don't actually want to use
# krew to install any plugins for the devcontainer. We only install krew for
# the user to allow for easy plugin installation later.
# For the same reason we also don't let krew self-host.
# See: <https://github.com/kubernetes-sigs/krew/issues/343>
install_krew() {
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64' 'ppc64le')"
    local archive_file='/tmp/krew.tar.gz'
    local bin_name="krew-linux_${arch}"
    curl -sSfL -o "${archive_file}" "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/${bin_name}.tar.gz"
    tar -xzf "${archive_file}" -C /tmp "./${bin_name}"
    install -m 555 "/tmp/${bin_name}" /usr/local/bin/kubectl-krew
    rm "${archive_file}" "/tmp/${bin_name}"
}

install_cnpg() {
    # Manually download the public key like this because we don't want to install the full gpg suite.
    local keyring_file='/tmp/cnpg_gpg.gpg'
    curl -sSfL -o "${keyring_file}.asc" 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0950e76b93bc38d112b090f407bdb5f9e33e0d6d'
    gpg --dearmor -o "${keyring_file}" "${keyring_file}.asc"

    local arch
    arch="$(base__pick_architecture 'arm64' 'ppc64le' 's390x' 'x86_64')"
    local deb_file='/tmp/kubectl-cnpg.deb'
    local url="https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v${CNPG_VERSION}/kubectl-cnpg_${CNPG_VERSION}_linux_${arch}.deb"
    curl -sSfL -o "${deb_file}" "${url}"
    curl -sSfL -o "${deb_file}.sig" "${url}.sig"
    gpg --keyring "${keyring_file}" --verify "${deb_file}.sig" "${deb_file}"
    dpkg -i "${deb_file}"
    rm "${deb_file}" "${deb_file}.sig" "${keyring_file}" "${keyring_file}.asc"
}

install_kubeseal() {
    local work_dir='/tmp/kubeseal'
    mkdir -p "${work_dir}"
    local arch
    arch="$(base__pick_architecture 'amd64' 'arm' 'arm64')"
    local archive_file="${work_dir}/kubeseal.tar.gz"
    local url="https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-${arch}.tar.gz"
    curl -sSfL -o "${archive_file}" "${url}"
    curl -sSfL -o "${archive_file}.sig" "${url}.sig"
    cosign verify-blob "${archive_file}" --signature "${archive_file}.sig" --key https://raw.githubusercontent.com/bitnami-labs/sealed-secrets/946bc048f3407117c837da6e4300686522d4c4eb/.github/workflows/cosign.pub
    tar -xzf "${archive_file}" -C "${work_dir}" kubeseal
    install -m 755 "${work_dir}/kubeseal" /usr/local/bin/kubeseal
    rm -rf "${work_dir}"
}

base__apt_install "${APT_PACKAGES[@]}"
install_helm
install_argocd
install_dapr
install_talos
install_k9s
install_krew
install_cnpg
install_kubeseal
