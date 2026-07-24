#!/bin/bash
set -e

# 저장소 루트(source/)에서 실행되도록 이동
cd "$(dirname "$0")"

for script in ./scripts/*.sh; do
    echo "[*] Running $script"
    bash "$script"
done

echo "[✔] Initial vol/ is ready"
