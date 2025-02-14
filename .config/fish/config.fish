if status is-interactive
  # Starship for prompt
  starship init fish | source

  # Gotta have vi mode
  fish_vi_key_bindings

  # Fun lil greeting when starting up the shell
  function fish_greeting
    fortune | cowsay
  end

  # Set terminal title
  function fish_title
    set -l cmd (status current-command 2>/dev/null; or echo "fish")
    set -l dir (prompt_pwd)

    if test "$cmd" = "fish"
      echo $dir
    else
      echo "$dir: $cmd"
    end
  end
end
