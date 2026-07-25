FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server ca-certificates locales

RUN mkdir -p /var/run/sshd

RUN echo "Port 22                              \n\
    PermitRootLogin yes                        \n\
    PasswordAuthentication no                  \n\
    PubkeyAuthentication yes                   \n\
    ClientAliveInterval 0                      \n\
    ClientAliveCountMax 0                      \n\
    UsePAM no                                 \n\
    " > /etc/ssh/sshd_config

# 로케일 지정 (터미널 한글 입력 지원)
RUN locale-gen ko_KR.UTF-8

# 개발 패키지 설치
RUN apt-get install -y --no-install-recommends \
    python3 build-essential curl wget vim git unzip llvm cmake golang
RUN apt-get install -y --no-install-recommends \
    tmux

# node 설치
ENV FNM_DIR=/root/.local/share/fnm
ENV PATH="$FNM_DIR/bin:$FNM_DIR/aliases/default/bin:$PATH"
RUN curl -o- https://fnm.vercel.app/install | bash
RUN /root/.local/share/fnm/fnm install 22

# AI Agent 툴 설치
RUN npm install -g @google/gemini-cli && \
    npm install -g @anthropic-ai/claude-code && \
    npm install -g @openai/codex && \
    npm install -g @github/copilot

# .bashrc.d 로드 (2단계 깊이까지, *.sh만)
RUN cat <<'EOF' >> ~/.bashrc
if [ -d "$HOME/.bashrc.d" ]; then
    for f in "$HOME/.bashrc.d"/*.sh; do
        [ -r "$f" ] && . "$f"
    done
    for d in "$HOME/.bashrc.d"/*/; do
        [ -d "$d" ] || continue
        for f in "$d"*.sh; do
            [ -r "$f" ] && . "$f"
        done
    done
fi
EOF

COPY home/AGENTS.md /root/AGENTS.md
COPY home/AGENTS.md /root/CLAUDE.md
COPY home/AGENTS.md /root/GEMINI.md

ARG NAME=Agent
ENV NAME=$NAME
RUN echo "export PS1='\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]${NAME}@\h\[\033[00m\]:\[\033[01;34m\]\w$\[\033[00m\] '" >> /root/.bashrc

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
