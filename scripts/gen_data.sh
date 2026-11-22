#!/usr/bin/env bash
set -e

REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
SRC_FILE=$REPO_DIR/data/AGENTS.md
TARGET_DIR=./vol/data

for d in .claude .codex .copilot .gemini; do
    if [ ! -d "$TARGET_DIR/$d" ]; then
        mkdir -p "$TARGET_DIR/$d"
        echo "[+] Created $TARGET_DIR/$d"
    else
        echo "[=] $TARGET_DIR/$d already exists, skipping"
    fi
done

# 공용 지침(AGENTS.md)을 각 에이전트의 전역 지침 위치로 복사
# 중복된 대상이 있다면 건너뜀
for rel in .claude/CLAUDE.md .codex/AGENTS.md .gemini/GEMINI.md; do
    dst="$TARGET_DIR/$rel"
    if [ ! -f "$dst" ]; then
        cp "$SRC_FILE" "$dst"
        echo "[+] Copied AGENTS.md to $rel"
    else
        echo "[=] $rel already exists, skipping"
    fi
done

echo "[✔] Agent data directories are ready in $TARGET_DIR"
