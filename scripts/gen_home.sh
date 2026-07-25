#!/bin/bash
set -e

SRC_DIR=./home
TARGET_DIR=./vol/home
mkdir -p "$TARGET_DIR"

# AGENTS.md는 vol이 아니라 Dockerfile COPY로 이미지에 포함됨
(cd "$SRC_DIR" && find . -type f ! -name AGENTS.md) | while read -r rel; do
    rel="${rel#./}"
    src="$SRC_DIR/$rel"
    dst="$TARGET_DIR/$rel"
    if [ ! -f "$dst" ]; then
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        echo "[+] Copied $rel"
    else
        echo "[=] $rel already exists, skipping"
    fi
done

echo "[✔] Home files are ready in $TARGET_DIR"
