#!/usr/bin/env bash
set -e

TARGET_DIR=./vol/ssh
mkdir -p "$TARGET_DIR"

# RSA
KEYFILE="$TARGET_DIR/ssh_host_rsa_key"
if [ ! -f "$KEYFILE" ]; then
    rm -f "$KEYFILE.pub"
    ssh-keygen -t rsa -b 4096 -f "$KEYFILE" -N ""
    echo "[+] Generated RSA host key"
elif [ ! -f "$KEYFILE.pub" ]; then
    ssh-keygen -y -f "$KEYFILE" > "$KEYFILE.pub"
    echo "[+] Restored RSA host public key from private key"
else
    echo "[=] RSA host key already exists, skipping"
fi

# ED25519
KEYFILE="$TARGET_DIR/ssh_host_ed25519_key"
if [ ! -f "$KEYFILE" ]; then
    rm -f "$KEYFILE.pub"
    ssh-keygen -t ed25519 -f "$KEYFILE" -N ""
    echo "[+] Generated ED25519 host key"
elif [ ! -f "$KEYFILE.pub" ]; then
    ssh-keygen -y -f "$KEYFILE" > "$KEYFILE.pub"
    echo "[+] Restored ED25519 host public key from private key"
else
    echo "[=] ED25519 host key already exists, skipping"
fi

chmod 600 "$TARGET_DIR"/ssh_host_*_key
chmod 644 "$TARGET_DIR"/ssh_host_*_key.pub
echo "[✔] SSH host keys are ready in $TARGET_DIR"
