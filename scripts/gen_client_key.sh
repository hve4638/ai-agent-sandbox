#!/usr/bin/env bash
set -e

TARGET_DIR=./vol/client_keys
mkdir -p "$TARGET_DIR"

KEYFILE="$TARGET_DIR/id_rsa"

if [ ! -f "$KEYFILE" ]; then
    rm -f "$KEYFILE.pub"
    ssh-keygen -t rsa -b 4096 -f "$KEYFILE" -N ""
    echo "[+] Generated client key"
elif [ ! -f "$KEYFILE.pub" ]; then
    ssh-keygen -y -f "$KEYFILE" > "$KEYFILE.pub"
    echo "[+] Restored client public key from private key"
else
    echo "[=] Client key already exists, skipping"
fi

chmod 600 "$KEYFILE"
chmod 644 "$KEYFILE.pub"
echo "[✔] Client key is ready in $TARGET_DIR"
