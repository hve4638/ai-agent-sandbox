#!/bin/bash
set -e

TARGET_DIR=./vol/client_keys
mkdir -p "$TARGET_DIR"

KEYFILE="$TARGET_DIR/id_rsa"

if [ -f "$KEYFILE" ]; then
    echo "[=] Client key already exists at $KEYFILE"
else
    ssh-keygen -t rsa -b 4096 -f "$KEYFILE" -N ""
    chmod 600 "$KEYFILE"
    chmod 644 "$KEYFILE.pub"
fi
