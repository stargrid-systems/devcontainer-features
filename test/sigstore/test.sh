#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'cosign is installed' cosign version
check 'rekor-cli is installed' rekor-cli version
check 'gitsign is installed' gitsign version

# TODO: enable after next base release (required for bash_completion!)
# # Shell completions tests
# for bin in cosign rekor-cli gitsign; do
#     check "bash ${bin} autocomplete works" bash -c ". /usr/share/bash-completion/bash_completion && __load_completion ${bin} && complete -p ${bin}"
# done

reportResults
