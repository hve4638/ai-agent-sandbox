# Agent Sandbox

에이전트(Claude Code, Codex)를 위한 Docker 기반 격리 개발 환경

## 요구사항

- Docker & Docker Compose

## 빠른 시작

### 1. docker-compose.yml 생성

템플릿을 복사해 로컬 설정 파일 생성

```bash
cp docker-compose.template.yml docker-compose.yml
```

### 2. 볼륨 경로 설정

`docker-compose.yml`에서 작업 디렉토리 경로를 환경에 맞게 수정

```yaml
volumes:
  - /path/to/your/workspace:/playground  # 실제 작업 디렉토리로 변경
```

### 3. 셋업

SSH 키(호스트, 클라이언트), 에이전트 데이터 디렉토리, bootstrap.d 시드를 생성

```bash
./init.sh
```

### 4. (선택) PS1 이름 설정

셸 프롬프트에 표시될 이름을 변경하려면 `.env` 생성 후 수정

```bash
cp .env.example .env
# SANDBOX_NAME=Agent 값을 원하는 이름으로 변경
```

### 5. 컨테이너 실행

```bash
docker-compose up -d --build
```

### 6. SSH 접속

```bash
ssh -i ./vol/client_keys/id_rsa -p 1022 root@localhost
```

## 유의사항

⚠️ 작업 디렉토리
- `/playground` 디렉토리 내에서만 작업
- 컨테이너 제거 시 `/playground` 외부의 작업 내역은 모두 휘발됨

⚠️ 프로젝트 관리
- 기존 작업 폴더를 통째로 마운트하지 말 것
- AI에게 접근을 허용할 프로젝트만 별도 폴더에 넣어 `/playground`에 연결

⚠️ 백업
- 작업 내역은 주기적으로 백업 권장 (git 원격 저장소, 외부 저장소 복제 등)

## 컨테이너 구성

### 설치된 도구

| 카테고리 | 도구 |
|---------|------|
| 언어 | Python3, Node.js 22, Go |
| 빌드 | build-essential, cmake, llvm |
| 유틸리티 | git, vim, tmux, curl, wget, unzip |
| AI 에이전트 CLI | Gemini CLI, Claude Code CLI, OpenAI Codex CLI, GitHub Copilot CLI |

## bootstrap.d

이미지에 넣기엔 인스턴스마다 다른 초기 설정(추가 패키지, 플러그인 설치, 설정 반영 등)을 호스트 쪽 스크립트로 처리하는 방식.

`vol/bootstrap.d/` 아래에 유닛 디렉터리를 만들고 그 안에 `entrypoint.sh`를 두면, 컨테이너 기동 시 이름순으로 실행된다.

```
vol/bootstrap.d/
├── 10-apt/
│   └── entrypoint.sh
└── 20-my-setup/
    ├── entrypoint.sh
    └── (유닛이 쓰는 파일들)
```

저장소 루트에 `bootstrap.d/`를 두면 **초기 세팅값(시드)** 으로 취급한다. `init.sh`가 `vol/bootstrap.d/`로
복사하며, 이미 있는 파일은 건너뛴다. 복사된 뒤로는 인스턴스 소유이므로 자유롭게 고쳐도 된다.
(기본 제공 시드는 없다. 필요한 인스턴스가 직접 유닛을 추가하면 된다.)

셸 설정을 배치하는 유닛이라면 `~/.bashrc.d/` 아래 두 갈래를 구분한다.

| 위치 | 성격 | 로드 순서 |
|---|---|---|
| `~/.bashrc.d/*.sh` | 이미지(`rootfs/`)에 포함된 템플릿 기본값 | 1단계 — 먼저 |
| `~/.bashrc.d/<dir>/*.sh` | bootstrap 유닛이 배치하는 인스턴스 설정 | 2단계 — 나중 |

로더가 1단계를 먼저 읽으므로 인스턴스 설정이 템플릿 기본값을 덮어쓴다. `local/`을 쓰면 무난하다.

### 실행 규칙

- **컨테이너당 1회.** 유닛 디렉터리 전체의 해시를 `/var/lib/bootstrap.d/<unit>`에 기록하고, 다음 기동 때 해시가 같으면 건너뛴다
- **내용이 바뀌면 다시 실행된다.** 스크립트를 고치면 별도 조치 없이 다음 기동 때 반영됨. 따라서 **유닛은 멱등하게 작성할 것**
- 마커는 컨테이너 레이어에 있으므로 `docker restart`는 건너뛰고, 컨테이너를 재생성하면 다시 실행된다
- 유닛이 실패하면 마커를 남기지 않고 다음 유닛으로 넘어간다. 컨테이너는 정상 기동하므로 SSH로 들어가 `docker logs`와 함께 원인을 확인하면 된다
- 실행 비트는 필요 없다 (`bash entrypoint.sh`로 호출)
- 작업 디렉터리는 해당 유닛 디렉터리다

### 확인

```bash
docker compose logs sandbox | grep bootstrap
```

## tmux 사용법

`tmux`는 하나의 터미널에서 여러 가상 세션을 생성하고 관리하는 도구로 SSH 연결이 끊어지거나 터미널을 종료해도 tmux 세션 내 작업은 계속 유지되므로 장시간 작업 및 에이전트 유지 시 유용함.

| Alias | 명령어 | 설명 |
|-------|--------|------|
| `tn` / `tnew` | `tmux new-session -s` | 새 세션 생성 |
| `ta` | `tmux attach-session -t` | 세션 연결 |
| `tk` / `tkill` | `tmux kill-session -t` | 세션 종료 |
| `tl` / `tls` | `tmux list-sessions` | 세션 목록 |
| `td` | `tmux detach` | 세션 분리 |
| `tr` / `trename` | `tmux rename-session -t` | 세션 이름 변경 |
| `tcapture` | `tmux capture-pane -p -S -` | 스크롤백 전체 출력 |

## AI Agent

### 에이전트 alias

컨테이너에 AI 코딩 에이전트가 사전 설치되어 있으며 YOLO 모드(파일 수정, 삭제, 명령어 실행 등을 확인 없이 수행)로 설정되어 있으므로 주의 필요.

| Alias | 원본 명령어 |
|-------|------------|
| `claude` | `claude --dangerously-skip-permissions` |
| `copilot` | `copilot --allow-all-tools` |
| `codex` | `codex --yolo` |
| `gemini` | `gemini --yolo` |

## 라이선스

MIT License
