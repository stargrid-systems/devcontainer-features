#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'cargo-binstall is installed' cargo-binstall -V
check 'library.sh is present' test -f /usr/local/share/devcontainers/base/library.sh
check 'library.sh can be sourced' bash -c 'source /usr/local/share/devcontainers/base/library.sh'
check 'git is installed' git --version

reportResults
