FROM alpine:edge

RUN apk update \
  && apk add --no-cache \
    bash \
    curl \
    fish \
    gawk \
    git \
    go \
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
  && sh -c "$(curl -fsSL https://starship.rs/install.sh)"

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

ENTRYPOINT ["zsh"]
