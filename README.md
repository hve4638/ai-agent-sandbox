# AI Agent Playground

AI 코딩 에이전트(Claude Code, Gemini CLI)를 위한 Docker 기반 격리 개발 환경

## 요구사항

- Docker & Docker Compose
- Bash 쉘 (키 생성 스크립트 실행용)

## 빠른 시작

### 1. 볼륨 경로 설정

`docker-compose.yml`에서 작업 디렉토리 경로를 환경에 맞게 수정

```yaml
volumes:
  - /your/work/directory:/playground  # `/your/work/directory`를 실제 작업 디렉토리로 변경
```

### 2. SSH 키 생성

```bash
# SSH 호스트 키 생성 (RSA, ED25519)
./gen_ssh_host.sh

# 클라이언트 키 생성
./gen_client_key.sh
```

### 3. 컨테이너 실행

```bash
docker-compose up -d --build
```

### 4. SSH 접속

```bash
ssh -i ./vol/client_keys/id_rsa -p 5024 root@localhost
```

## 유의사항

⚠️ **작업 디렉토리**
- `/playground` 디렉토리 내에서만 작업
- 컨테이너 종료 시 `/playground` 외부의 작업 내역은 모두 휘발됨

⚠️ **프로젝트 관리**
- 기존 작업 폴더를 통째로 마운트하지 말 것
- AI에게 접근을 허용할 프로젝트만 별도 폴더에 넣어 `/playground`에 연결

⚠️ **백업**
- 작업 내역은 주기적으로 백업 권장 (git commit, 외부 저장소 복제 등)

## 컨테이너 구성

### 설치된 도구

| 카테고리 | 도구 |
|---------|------|
| 언어 | Python3, Node.js 22, Go |
| 빌드 | build-essential, cmake, llvm |
| 유틸리티 | git, vim, tmux, curl, wget, unzip |

### 포트 매핑

| 호스트 | 컨테이너 | 용도 |
|--------|---------|------|
| 5024 | 22 | SSH 접속 |
| 8500-8599 | 8500-8599 | 애플리케이션 |

> 포트 매핑 수정: `docker-compose.yml`의 `ports` 섹션에서 변경

### 볼륨 마운트

| 호스트 | 컨테이너 | 설명 |
|--------|---------|------|
| `/nas/storage1/.volume/ai-control` | `/playground` | 작업 디렉토리 |
| `./vol/client_keys/id_rsa.pub` | `/root/.ssh/authorized_keys` | SSH 인증 |
| `./vol/home/CLAUDE.md` | `/root/CLAUDE.md` | Claude 에이전트 지침 |
| `./vol/home/GEMINI.md` | `/root/GEMINI.md` | Gemini 에이전트 지침 |

## 디렉토리 구조

```
.
├── docker-compose.yml      # 서비스 정의
├── Dockerfile              # 이미지 빌드 설정
├── gen_client_key.sh       # 클라이언트 SSH 키 생성
├── gen_ssh_host.sh         # 호스트 SSH 키 생성
├── README.md
└── vol/
    ├── client_keys/        # SSH 클라이언트 키 (gitignore)
    │   ├── id_rsa
    │   └── id_rsa.pub
    ├── ssh/                # SSH 호스트 키 (gitignore)
    │   ├── ssh_host_ed25519_key
    │   ├── ssh_host_ed25519_key.pub
    │   ├── ssh_host_rsa_key
    │   └── ssh_host_rsa_key.pub
    └── home/               # 홈 디렉토리 설정
        ├── .bashrc.extra
        ├── .tmux.conf
        ├── CLAUDE.md
        └── GEMINI.md
```

## tmux 사용법

`tmux`는 하나의 터미널에서 여러 가상 세션을 생성하고 관리하는 도구로 SSH 연결이 끊어지거나 터미널을 종료해도 tmux 세션 내 작업은 계속 유지되므로 장시간 작업 시 유용하다.

### Alias 목록

| Alias | 명령어 | 설명 |
|-------|--------|------|
| `tn` / `tnew` | `tmux new-session -s` | 새 세션 생성 |
| `ta` | `tmux attach-session -t` | 세션 연결 |
| `tk` / `tkill` | `tmux kill-session -t` | 세션 종료 |
| `tl` / `tls` | `tmux list-sessions` | 세션 목록 |
| `td` | `tmux detach` | 세션 분리 |
| `tr` / `trename` | `tmux rename-session -t` | 세션 이름 변경 |

### 사용 예시

```bash
# 새 세션 생성
tn myproject

# 세션 목록 확인
tl

# 기존 세션에 연결
ta myproject

# 세션 종료
tk myproject
```

## AI Agent

컨테이너에 AI 코딩 에이전트가 사전 설치되어 있다.

YOLO 모드(파일 수정, 삭제, 명령어 실행 등을 확인 없이 수행)로 설정되어 있으므로 주의 필요.

| Alias | 원본 명령어 | 설명 |
|-------|------------|------|
| `claude` | `claude --dangerously-skip-permissions` | Claude Code 실행 (권한 확인 스킵) |
| `copilot` | `copilot --allow-all-tools` | GitHub Copilot 실행 (모든 도구 허용) |

## 라이선스

MIT License
