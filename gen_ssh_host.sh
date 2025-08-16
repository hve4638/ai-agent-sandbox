#!/bin/bash
set -e

TARGET_DIR=./vol/ssh
mkdir -p "$TARGET_DIR"

# RSA (호환성 가장 넓음, 기본적으로 충분)
if [ ! -f "$TARGET_DIR/ssh_host_rsa_key" ]; then
    ssh-keygen -t rsa -b 4096 -f "$TARGET_DIR/ssh_host_rsa_key" -N ""
    echo "[+] Generated RSA host key"
else
    echo "[=] RSA host key already exists, skipping"
fi

# ED25519 (현대적이고 가볍고 보안성 높음)
if [ ! -f "$TARGET_DIR/ssh_host_ed25519_key" ]; then
    ssh-keygen -t ed25519 -f "$TARGET_DIR/ssh_host_ed25519_key" -N ""
    echo "[+] Generated ED25519 host key"
else
    echo "[=] ED25519 host key already exists, skipping"
fi

chmod 600 ./vol/ssh/ssh_host_*_key
chmod 644 ./vol/ssh/ssh_host_*_key.pub
echo "[✔] SSH host keys are ready in $TARGET_DIR"
