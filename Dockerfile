FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server ca-certificates locales

RUN mkdir -p /var/run/sshd

RUN echo "Port 22                           \n\
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
    npm install -g @anthropic-ai/claude-code

# tmux alias 지정
RUN echo 'alias tn="tmux new-session -s"' >> /root/.bashrc && \
    echo 'alias ta="tmux attach-session -t"' >> /root/.bashrc && \
    echo 'alias tk="tmux kill-session -t"' >> /root/.bashrc && \
    echo 'alias tl="tmux list-sessions"' >> /root/.bashrc && \
    echo 'alias td="tmux detach"' >> /root/.bashrc

# tmux alias
RUN echo 'set -g mouse on' >> /root/.tmux.conf && \
    echo 'set -g default-terminal "screen-256color"' >> /root/.tmux.conf && \
    echo '' >> /root/.tmux.conf

RUN echo 'if [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then' >> /root/.bashrc && \
    echo '  if tmux list-sessions 2>/dev/null >/dev/null; then' >> /root/.bashrc && \
    echo '    echo -e "TMUX Sessions"' >> /root/.bashrc && \
    echo '    tmux list-sessions -F "* #{session_name}" 2>/dev/null' >> /root/.bashrc && \
    echo '    echo ""' >> /root/.bashrc && \
    echo '  else' >> /root/.bashrc && \
    echo '    echo "No tmux session"' >> /root/.bashrc && \
    echo '  fi' >> /root/.bashrc && \
    echo '  echo "tmux usage: tn [session_name] | ta [session_name] | tk [session_name] | tl"' >> /root/.bashrc && \
    echo 'fi' >> /root/.bashrc && \
    echo '' >> /root/.bashrc

RUN echo 'export LC_ALL=ko_KR.UTF-8' >> /root/.bashrc && \
    echo 'export LANG=ko_KR.UTF-8'>> /root/.bashrc

# 이름 지정
ENV NAME=Agent
RUN echo "export PS1='\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]${NAME}@\h\[\033[00m\]:\[\033[01;34m\]\w$\[\033[00m\] '" >> /root/.bashrc

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
