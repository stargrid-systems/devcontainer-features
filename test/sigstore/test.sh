#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'cosign is installed' cosign version

# TODO: enable after next base release (required for bash_completion!)
# # Shell completions tests
# # butane doesn't have any autocomplete
# for bin in cosign; do
#     check "bash ${bin} autocomplete works" bash -c ". /usr/share/bash-completion/bash_completion && __load_completion ${bin} && complete -p ${bin}"
# done

reportResults
