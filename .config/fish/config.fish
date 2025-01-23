if status is-interactive
  # Starship for prompt
  starship init fish | source

 # Fun lil greeting when starting up the shell
  function fish_greeting
    fortune | cowsay
  end
end
