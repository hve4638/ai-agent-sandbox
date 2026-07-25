#!/bin/bash
set -e

TARGET_DIR=./vol/data

for d in .claude .codex .copilot .gemini; do
    if [ ! -d "$TARGET_DIR/$d" ]; then
        mkdir -p "$TARGET_DIR/$d"
        echo "[+] Created $TARGET_DIR/$d"
    else
        echo "[=] $TARGET_DIR/$d already exists, skipping"
    fi
done

echo "[✔] Agent data directories are ready in $TARGET_DIR"
