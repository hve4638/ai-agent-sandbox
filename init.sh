#!/usr/bin/env bash
set -e

REPO_DIR=$(cd "$(dirname "$0")" && pwd)
DEPLOY_DIR=$(dirname "$REPO_DIR")

# 저장소는 배포 폴더의 source/ 에 있어야 한다 (템플릿 경로가 source/ 기준)
if [ "$(basename "$REPO_DIR")" != "source" ]; then
    echo "[!] Clone this repository as 'source': git clone <repo> source" >&2
    exit 1
fi

cd "$DEPLOY_DIR"

echo "[*] Repository : $REPO_DIR"
echo "[*] Target     : $DEPLOY_DIR"

for script in "$REPO_DIR"/scripts/*.sh; do
    echo "[*] Running $(basename "$script")"
    bash "$script"
done

echo "[✔] Deploy directory is ready at $DEPLOY_DIR"
