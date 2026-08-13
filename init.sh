#!/bin/bash
set -e

REPO_DIR=$(cd "$(dirname "$0")" && pwd)

echo "[*] Repository : $REPO_DIR"
echo "[*] Target     : $(pwd)/vol"

for script in "$REPO_DIR"/scripts/*.sh; do
    echo "[*] Running $(basename "$script")"
    bash "$script"
done

echo "[✔] Initial vol/ is ready at $(pwd)/vol"
