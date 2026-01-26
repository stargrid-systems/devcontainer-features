#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'dev user' test "$(whoami)" = "dev"
check 'rustup toolchain nightly-2025-12-27 is installed' bash -c "rustup toolchain list | grep -q 'nightly-2025-12-27'"

reportResults
