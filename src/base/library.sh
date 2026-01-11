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

# Usage: base__contains_element <element> <array...>
#
# Returns 0 if the element is found in the array, 1 otherwise.
base__contains_element() {
    local element match="$1"
    shift
    for element; do
        if [ "$element" = "$match" ]; then
            return 0
        fi
    done
    return 1
}

# Usage: base__pick_architecture <architecture...>
#
# Takes a list of architectures and prints the one matching the current system.
# If none match, prints an error and returns a non-zero exit code.
base__pick_architecture() {
    # Debian supports: amd64, arm64, armel, armhf, i386, ppc64el, riscv64, s390x
    local arch="${OVERRIDE_ARCH:-}"
    if [ -z "$arch" ]; then
        arch="$(dpkg --print-architecture)"
    fi
    # Direct match
    if base__contains_element "$arch" "$@"; then
        printf '%s\n' "$arch"
        return 0
    fi
    # Handle aliases
    case "$arch" in
        amd64)
            for alias in "x86_64" "x64"; do
                if base__contains_element "$alias" "$@"; then
                    printf '%s\n' "$alias"
                    return 0
                fi
            done
            ;;
        arm64)
            for alias in "aarch64"; do
                if base__contains_element "$alias" "$@"; then
                    printf '%s\n' "$alias"
                    return 0
                fi
            done
            ;;
        armel|armhf)
            for alias in "armv6" "armv7" "arm"; do
                if base__contains_element "$alias" "$@"; then
                    printf '%s\n' "$alias"
                    return 0
                fi
            done
            ;;
        i386)
            if base__contains_element "386" "$@"; then
                printf '386\n'
                return 0
            fi
            ;;
    esac
    printf >&2 'Error: Unsupported architecture: %s\n' "$arch" 
    return 1
}
