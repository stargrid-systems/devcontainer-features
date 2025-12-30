#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'go is installed' go version
check 'golangci-lint is installed' golangci-lint --version
check 'goreleaser is installed' goreleaser --version

reportResults
