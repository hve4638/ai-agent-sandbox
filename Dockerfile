FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server ca-certificates locales

RUN mkdir -p /var/run/sshd

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

# 프롬프트 값. .bashrc.d 로더보다 먼저 설정되어야 한다
ARG NAME=sandbox
ARG COLOR=32
RUN echo "PS1_NAME=$NAME"   >> /root/.bashrc && \
    echo "PS1_COLOR=$COLOR" >> /root/.bashrc

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

COPY rootfs/ /

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
