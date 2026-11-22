#!/usr/bin/env bash
set -e

REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
SRC_DIR=$REPO_DIR/bootstrap.d
TARGET_DIR=./vol/bootstrap.d
mkdir -p "$TARGET_DIR"

# 초기 bootstrap.d 를 vol/bootstrap.d 로 복사
# 중복된 대상이 있다면 건너뜀
if [ -d "$SRC_DIR" ]; then
    (cd "$SRC_DIR" && find . -type f) | while read -r rel; do
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
fi

echo "[✔] bootstrap.d is ready in $TARGET_DIR"
