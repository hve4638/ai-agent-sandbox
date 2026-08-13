#!/bin/bash
# bootstrap.d 러너
#
# /opt/bootstrap.d/<unit>/entrypoint.sh 를 이름순으로 1회 실행한다.
# 유닛 디렉터리 전체의 해시를 기록해 두고, 다음 기동 때 해시가 같으면 건너뛴다.
# 즉 "컨테이너당 1회 + 내용이 바뀌면 재실행"이다.
#
# 마커는 컨테이너 레이어(/var/lib/bootstrap.d)에 둔다.
# - docker restart      : 레이어 유지 -> 건너뜀
# - 컨테이너 재생성      : 레이어 소멸 -> 다시 실행
# 볼륨에 두면 파일시스템은 초기 상태인데 마커만 남아 프로비저닝이 누락되므로 두지 않는다.
#
# 유닛이 실패해도 마커를 남기지 않고 계속 진행한다. (다음 기동 때 재시도)
# 컨테이너 자체는 뜨게 두어야 SSH로 들어가 원인을 볼 수 있다.

BOOTSTRAP_DIR=${BOOTSTRAP_DIR:-/opt/bootstrap.d}
STATE_DIR=${BOOTSTRAP_STATE_DIR:-/var/lib/bootstrap.d}

run_bootstrap() {
    [ -d "$BOOTSTRAP_DIR" ] || return 0
    mkdir -p "$STATE_DIR"

    local unit name entry hash
    for unit in "$BOOTSTRAP_DIR"/*/; do
        [ -d "$unit" ] || continue
        name=$(basename "$unit")
        entry="${unit}entrypoint.sh"

        if [ ! -f "$entry" ]; then
            echo "[-] bootstrap $name: entrypoint.sh 없음, 건너뜀"
            continue
        fi

        # 경로/내용/실행권한만 반영. mtime 은 마운트마다 달라지므로 제외한다.
        hash=$(
            {
                find "$unit" -type f -exec sha256sum {} +
                find "$unit" -type f -exec stat -c '%n %a' {} +
            } | sort | sha256sum | cut -d' ' -f1
        )

        if [ "$(cat "$STATE_DIR/$name" 2>/dev/null)" = "$hash" ]; then
            echo "[=] bootstrap $name: 변경 없음, 건너뜀"
            continue
        fi

        echo "[*] bootstrap $name"
        # 실행 비트가 없어도 되도록 bash 로 직접 호출한다 (호스트에서 마운트되는 파일이라)
        if (cd "$unit" && bash entrypoint.sh); then
            echo "$hash" > "$STATE_DIR/$name"
            echo "[+] bootstrap $name: 완료"
        else
            echo "[!] bootstrap $name: 실패 (다음 기동 시 재시도)" >&2
        fi
    done
}

run_bootstrap

exec "$@"
