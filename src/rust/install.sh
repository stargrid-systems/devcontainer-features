#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../base/library.sh
source /usr/local/share/devcontainers/base/library.sh

# renovate: datasource=github-releases depName=bindgen packageName=rust-lang/rust-bindgen
BINDGEN_VERSION=0.72.1
# renovate: datasource=github-tags depName=cargo-all-features packageName=frewsxcv/cargo-all-features
CARGO_ALL_FEATURES_VERSION=1.12.0
# renovate: datasource=github-tags depName=cargo-deb packageName=kornelski/cargo-deb
CARGO_DEB_VERSION=3.6.2
# renovate: datasource=github-releases depName=cargo-deny packageName=EmbarkStudios/cargo-deny
CARGO_DENY_VERSION=0.18.9
# renovate: datasource=crate packageName=cargo-nextest versioning=semver
CARGO_NEXTEST_VERSION=0.9.116
# renovate: datasource=github-releases depName=cargo-semver-checks packageName=obi1kenobi/cargo-semver-checks
CARGO_SEMVER_CHECKS_VERSION=0.45.0
# renovate: datasource=github-releases depName=cargo-shear packageName=Boshen/cargo-shear
CARGO_SHEAR_VERSION=1.9.1
# renovate: datasource=github-releases depName=cargo-udeps packageName=est31/cargo-udeps
CARGO_UDEPS_VERSION=0.1.60
# renovate: datasource=github-releases depName=kani packageName=model-checking/kani
KANI_VERSION=0.66.0
# renovate: datasource=crate packageName=release-plz versioning=semver
RELEASE_PLZ_VERSION=0.3.150

APT_PACKAGES=(
    'cmake'        # Unfortunately used by some rust crates
    'gcc'          # Required for building rust crates with C/C++ code
    'libclang-dev' # Required for 'bindgen'
    'rustup'
)
CARGO_BINSTALL_PACKAGES=(
    "bindgen-cli@${BINDGEN_VERSION}"
    "cargo-all-features@${CARGO_ALL_FEATURES_VERSION}"
    "cargo-deb@${CARGO_DEB_VERSION}"
    "cargo-deny@${CARGO_DENY_VERSION}"
    "cargo-nextest@${CARGO_NEXTEST_VERSION}"
    "cargo-semver-checks@${CARGO_SEMVER_CHECKS_VERSION}"
    "cargo-shear@${CARGO_SHEAR_VERSION}"
    "cargo-udeps@${CARGO_UDEPS_VERSION}"
    "kani-verifier@${KANI_VERSION}"
    "release-plz@${RELEASE_PLZ_VERSION}"
)

base__apt_install "${APT_PACKAGES[@]}"
# TODO: we should support passing a secret github token to cargo-binstall to avoid getting rate-limited
base__cargo_binstall "${CARGO_BINSTALL_PACKAGES[@]}"

sudo --user="${_REMOTE_USER}" ./install-remote-user.sh
