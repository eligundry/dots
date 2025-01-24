if status is-interactive
  # Starship for prompt
  starship init fish | source

  # Gotta have vi mode
  fish_vi_key_bindings

  # Fun lil greeting when starting up the shell
  function fish_greeting
    fortune | cowsay
  end
end
