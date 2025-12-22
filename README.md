# AI Agent Playground

AI 코딩 에이전트(Claude Code, Gemini CLI)를 위한 Docker 기반 격리 개발 환경입니다.

## 요구사항

- Docker & Docker Compose
- Bash 쉘 (키 생성 스크립트 실행용)

## 빠른 시작

### 1. SSH 키 생성

```bash
# SSH 호스트 키 생성 (RSA, ED25519)
./gen_ssh_host.sh

# 클라이언트 키 생성
./gen_client_key.sh
```

### 2. 컨테이너 실행

```bash
docker-compose up -d --build
```

### 3. SSH 접속

```bash
ssh -i ./vol/client_keys/id_rsa -p 5024 root@localhost
```

## 컨테이너 구성

### 설치된 도구

| 카테고리 | 도구 |
|---------|------|
| 언어 | Python3, Node.js 22, Go |
| 빌드 | build-essential, cmake, llvm |
| 유틸리티 | git, vim, tmux, curl, wget, unzip |
| AI Agent | `@anthropic-ai/claude-code`, `@google/gemini-cli` |

### 포트 매핑

| 호스트 | 컨테이너 | 용도 |
|--------|---------|------|
| 5024 | 22 | SSH 접속 |
| 8500-8599 | 8500-8599 | 애플리케이션 |

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

## 설정 커스터마이징

### 작업 디렉토리 변경

`docker-compose.yml`에서 볼륨 마운트 경로를 수정하세요.

```yaml
volumes:
  - /your/work/directory:/playground
```

### SSH 포트 변경

`docker-compose.yml`에서 포트 매핑을 수정하세요:

```yaml
ports:
  - "원하는포트:22"
```

## 유용한 명령어

```bash
# 컨테이너 로그 확인
docker-compose logs -f

# 컨테이너 재시작
docker-compose restart

# 컨테이너 중지 및 삭제
docker-compose down

# 이미지 재빌드
docker-compose up -d --build --force-recreate
```

## 라이선스

MIT License
