#!/usr/bin/env bash
set -euo pipefail

# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check 'rustup is installed' rustup --version
check 'bindgen-cli is installed' bindgen --version
check 'cargo-all-features is installed' cargo-all-features --version
check 'cargo-deb is installed' cargo-deb --version
check 'cargo-deny is installed' cargo-deny --version
check 'cargo-nextest is installed' cargo-nextest --version
check 'cargo-semver-checks is installed' cargo-semver-checks --version
check 'cargo-shear is installed' cargo-shear --version
check 'cargo-udeps is installed' cargo-udeps udeps --version
check 'kani is installed' kani --version
check 'release-plz is installed' release-plz --version

reportResults
