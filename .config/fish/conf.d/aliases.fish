if status is-interactive
  alias v=nvim
  alias cp='cp -v'
  alias mv='mv -v'
  alias rm='rm -v'
  alias md='mkdir -pv'
  alias s='sudo'
  alias la='ls -A'
  alias ll='ls -lh'

  alias g='git'
  alias gst='git status'
  alias gb='git branch'
  alias gco='git checkout'
  alias gcotb='git checkout --track=direct -b'

  alias shadcn='pnpm dlx shadcn@latest'

  function ... --description 'cd up 2 directories'
    cd ../..
  end

  function .... --description 'cd up 3 directories'
    cd ../../..
  end

  function ..... --description 'cd up 4 directories'
    cd ../../../..
  end
end
