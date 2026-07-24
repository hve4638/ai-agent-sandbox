#!/bin/bash
set -e

SRC_DIR=./home
TARGET_DIR=./vol/home
mkdir -p "$TARGET_DIR"

for src in "$SRC_DIR"/* "$SRC_DIR"/.[!.]*; do
    [ -f "$src" ] || continue
    name="$(basename "$src")"
    if [ ! -f "$TARGET_DIR/$name" ]; then
        cp "$src" "$TARGET_DIR/$name"
        echo "[+] Copied $name"
    else
        echo "[=] $name already exists, skipping"
    fi
done

echo "[✔] Home files are ready in $TARGET_DIR"
