FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      python3 build-essential curl wget vim git sudo openssh-server ca-certificates

RUN mkdir -p /var/run/sshd

# RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN echo "Port 22                           \n\
PermitRootLogin yes                        \n\
PasswordAuthentication no                  \n\
PubkeyAuthentication yes                   \n\
ClientAliveInterval 0                      \n\
ClientAliveCountMax 0                      \n\
UsePAM no                                 \n\
" > /etc/ssh/sshd_config

RUN echo "export PS1='\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$\[\033[00m\] '" >> /root/.bashrc

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
COPY ./key/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
