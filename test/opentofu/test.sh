#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'tofu is installed' tofu --version
check 'terraform is installed' terraform --version
check 'hcloud is installed' hcloud version
check 'packer is installed' packer --version

for bin in tofu terraform hcloud packer; do
    check "bash ${bin} autocomplete works" bash -c ". /usr/share/bash-completion/bash_completion && __load_completion ${bin} && complete -p ${bin}"
done

reportResults
