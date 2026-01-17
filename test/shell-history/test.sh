#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# bash checks (use login shell to source .bashrc)
check "configures HISTFILE for bash" bash -lxc "test \$HISTFILE = /mnt/shell-history/.bash_history"
check "KUBECONFIG env variable is set" bash -lxc "test \$KUBECONFIG = /mnt/shell-history/config/kube/config.yaml"
check "TALOSCONFIG env variable is set" bash -lxc "test \$TALOSCONFIG = /mnt/shell-history/config/talos/config.yaml"

reportResults
