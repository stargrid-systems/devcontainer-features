#!/usr/bin/env bash
set -euo pipefail

HISTORY_MOUNT_DIR='/mnt/shell-history'

chown_to_user() {
    local dir="${1}"
    if [ ! -w "${dir}" ]; then
        sudo chown -R "$(id -u):$(id -g)" "${dir}"
    fi
}

print_common_shell_config() {
    cat <<EOF
export PROMPT_COMMAND='history -a'

export KUBECONFIG='${HISTORY_MOUNT_DIR}/config/kube/config.yaml'
export TALOSCONFIG='${HISTORY_MOUNT_DIR}/config/talos/config.yaml'
EOF
}

print_bash_config() {
    cat <<EOF
if [[ -z "\$HISTFILE_OLD" ]]; then
    export HISTFILE_OLD=\$HISTFILE
fi
export HISTFILE='${HISTORY_MOUNT_DIR}/.bash_history'
EOF
    print_common_shell_config
}

print_zsh_config() {
    cat <<EOF
export HISTFILE='${HISTORY_MOUNT_DIR}/.zsh_history'
EOF
    print_common_shell_config
}

apply_shell_config() {
    print_bash_config >>"$HOME/.bashrc"
    print_zsh_config >>"$HOME/.zshrc"
}

apply_shell_config
chown_to_user "${HISTORY_MOUNT_DIR}"
mkdir -p "${HISTORY_MOUNT_DIR}/config/kube" "${HISTORY_MOUNT_DIR}/config/talos"
