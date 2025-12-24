#!/usr/bin/env bash
set -euo pipefail

HISTORY_MOUNT_DIR='/mnt/shellhistory'

chown_to_user() {
    local dir="${1}"
    if [ ! -w "${dir}" ]; then
        sudo chown -R "$(id -u):$(id -g)" "${dir}"
    fi
}

configure_histfile() {
    # Set HISTFILE for bash
    cat <<EOF >>"$HOME/.bashrc"
if [[ -z "\$HISTFILE_OLD" ]]; then
    export HISTFILE_OLD=\$HISTFILE
fi
export HISTFILE=${HISTORY_MOUNT_DIR}/.bash_history
export PROMPT_COMMAND='history -a'
EOF

    # Set HISTFILE for zsh
    cat <<EOF >>"$HOME/.zshrc"
export HISTFILE=${HISTORY_MOUNT_DIR}/.zsh_history
export PROMPT_COMMAND='history -a'
EOF
}

main() {
    configure_histfile
    chown_to_user "${HISTORY_MOUNT_DIR}"

}

main "$@"
