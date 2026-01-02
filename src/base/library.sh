#!/usr/bin/env bash

base__apt_install() {
    declare -x DEBIAN_FRONTEND=noninteractive
    apt-get update || return
    apt-get install -y --no-install-recommends "$@" || return
    base__apt_cleanup
}

base__apt_cleanup() {
    declare -x DEBIAN_FRONTEND=noninteractive
    apt-get -y clean
    rm -rf /var/lib/apt/lists/*
}

base__npm_install() {
    npm install --global "$@" || return
    base__npm_cleanup
}

base__npm_cleanup() {
    npm cache clean --force || return
}

base__cargo_binstall() {
    cargo-binstall \
        --no-confirm \
        --strategies "crate-meta-data,quick-install" \
        --install-path "/usr/local/bin" \
        "$@" || return
}
