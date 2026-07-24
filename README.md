# AI Agent Playground

AI 코딩 에이전트(Claude Code, Gemini CLI)를 위한 Docker 기반 격리 개발 환경

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
  - /path/to/your/directory:/playground  # `/path/to/your/directory`를 실제 작업 디렉토리로 변경
```

### 3. SSH 키 생성

```bash
# SSH 호스트 키 생성 (RSA, ED25519)
./gen_ssh_host.sh

# 클라이언트 키 생성
./gen_client_key.sh
```

### 4. 컨테이너 실행

```bash
docker-compose up -d --build
```

### 5. SSH 접속

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

## 디렉토리 구조

```
.
├── docker-compose.template.yml # 서비스 템플릿 (git tracked)
├── docker-compose.yml      # 로컬 설정 (gitignore)
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

`tmux`는 하나의 터미널에서 여러 가상 세션을 생성하고 관리하는 도구로 SSH 연결이 끊어지거나 터미널을 종료해도 tmux 세션 내 작업은 계속 유지되므로 장시간 작업 및 에이전트 유지 시 유용함.

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
