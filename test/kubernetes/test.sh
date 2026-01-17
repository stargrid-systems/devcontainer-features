#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'kubectl is installed' kubectl version --client
check 'helm is installed' helm version
check 'argocd is installed' argocd version --client
check 'dapr is installed' dapr version
check 'talosctl is installed' talosctl version --client
check 'k9s is installed' k9s version
check 'krew is installed' kubectl krew version
check 'kubectl-cnpg is installed' kubectl cnpg version
check 'kubeseal is installed' kubeseal --version

reportResults
