FROM alpine:edge AS builder

RUN apk update \
  && apk add --no-cache \
    bash \
    curl \
    fish \
    gawk \
    git \
    go \
    lua \
    ncurses \
    neovim \
    nodejs \
    npm \
    openssh \
    perl \
    php7 \
    python3 \
    rust \
    the_silver_searcher \
    tmux \
    vim \
    zsh \
  && GO111MODULE=on go get golang.org/x/tools/gopls@latest \
  && curl -fsSL https://starship.rs/install.sh -o /install.sh \
  && chmod +x /install.sh \
  && /install.sh --yes \
  && rm /install.sh

ENV CI="true"
ENV HOME=/home/root
ENV TERM=xterm-256color
WORKDIR /home/root
ADD . /home/root/dots
RUN mkdir -p /home/root \
  && cd /home/root/dots \
  && ./dots.sh -i \
  && nvim +PlugInstall +qa \
  && zsh -c 'source ~/.zshrc && zplug install'

FROM alpine:edge

COPY --from=builder / /
ENV CI="true"
ENV HOME=/home/root
ENV TERM=xterm-256color
WORKDIR /home/root

ENTRYPOINT ["zsh"]
