#!/usr/bin/env bash

base__apt_install() {
    declare -x DEBIAN_FRONTEND=noninteractive
    apt-get update || return
    apt-get install -y --no-install-recommends "$@" || return
}

base__cargo_binstall() {
    cargo-binstall \
        --no-confirm \
        --strategies "crate-meta-data,quick-install" \
        --install-path "/usr/local/bin" \
        "$@" || return
}
