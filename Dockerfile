FROM ubuntu:22.04@sha256:0eb0f877e1c869a300c442c41120e778db7161419244ee5cbc6fa5f134e74736

RUN apt-get update && apt-get install -y \
    build-essential \
    fish \
    gdb \
    gdbserver \
    gdb-multiarch \
    binutils \
    python3 \
    python3-pip \
    libc6-dev-i386 \
    gcc-multilib \
    patchelf \
    git \
    curl\
    wget \
    ruby \
    ruby-dev \
    pkg-config \
    liblzma-dev \
    libssl-dev \
    tmux \
    strace \
    ltrace \
    netcat \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install ropr pwninit

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    pwntools \
    z3-solver

RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

RUN echo 'set -g mouse on' > ~/.tmux.conf && \
    echo 'unbind -T copy-mode MouseDragEnd1Pane' >> ~/.tmux.conf && \
    echo 'unbind -T copy-mode-vi MouseDragEnd1Pane' >> ~/.tmux.conf && \
    echo 'bind-key -T copy-mode C-c send-keys -X copy-pipe-and-cancel "clip.exe"' >> ~/.tmux.conf && \
    echo 'bind-key -T copy-mode-vi C-c send-keys -X copy-pipe-and-cancel "clip.exe"' >> ~/.tmux.conf

RUN echo "exec fish" >> ~/.bashrc

WORKDIR /workspace
