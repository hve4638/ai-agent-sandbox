#!/usr/bin/env bash
set -e

REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)

# 배포 폴더에 docker-compose.yml, .env 를 복사
# 중복된 대상이 있다면 건너뜀
copy_once() {
    local src="$1" dst="$2"
    if [ ! -f "$dst" ]; then
        cp "$src" "$dst"
        echo "[+] Created $dst"
    else
        echo "[=] $dst already exists, skipping"
    fi
}

copy_once "$REPO_DIR/docker-compose.template.yml" ./docker-compose.yml
copy_once "$REPO_DIR/.env.example" ./.env

echo "[✔] Compose files are ready"
