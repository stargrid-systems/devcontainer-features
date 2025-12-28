#!/usr/bin/env bash
set -euo pipefail

RUST_TOOLCHAIN=nightly-2025-12-27
TARGETS=()
COMPONENTS=(
    'clippy'
    'miri'
    'rustfmt'
)
COMPONENTS_CSV=$(
    IFS=','
    echo "${COMPONENTS[*]}"
)
rustup toolchain install \
    --profile=minimal \
    --component="${COMPONENTS_CSV}" \
    "${RUST_TOOLCHAIN}"
rustup default "${RUST_TOOLCHAIN}"
if [ ${#TARGETS[@]} -gt 0 ]; then
    rustup target add "${TARGETS[@]}"
fi

# Run kani first-time setup
cargo-kani setup
